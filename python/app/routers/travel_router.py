# app/routers/travel_router.py
from fastapi import APIRouter, HTTPException, Request, Depends
from fastapi.templating import Jinja2Templates
from app.schema.travel_schema import TravelKeywordRequest, TravelRecommendationResponse, ChatbotRequest, JHRequestDto, JHResponse, JHRequestDto2, JHResponse2
from app.services.model_service import TravelModelService
from app.services.chat_service import ChatService
from app.services.qna_service import QnaService
from app.database.database import get_db
from sqlalchemy.orm import Session
from typing import List

router = APIRouter()
model_service = TravelModelService()
templates = Jinja2Templates(directory="app/templates")

def get_chat_service(db: Session = Depends(get_db)):
    return ChatService(db)

def get_qna_service(db: Session = Depends(get_db)):
    return QnaService(db)

@router.get("/")
async def travel_page(request: Request):
    """메인 여행 추천 페이지 렌더링"""
    return templates.TemplateResponse("index.html", {
        "request": request,
        "username": "사용자",
        "total_distance": "0",
        "locations": "선택된 지역 없음",
        "recommended_places": "추천 장소 없음",
        "search_title": "새로운 여행을 시작해보세요"
    })

@router.post("/recommend", response_model=TravelRecommendationResponse)
async def get_travel_recommendations(request: TravelKeywordRequest):
    """
    키워드 기반 여행 추천 API
    - 지역, 일정, 테마 키워드를 받아서 추천 생성
    """
    try:
        recommendations, confidence = model_service.get_recommendations(
            location=request.location,
            schedule=request.schedule,
            theme=request.theme
        )
        return TravelRecommendationResponse(
            recommendations=recommendations,
            confidence_score=confidence,
            additional_info=f"키워드: {request.location}, {request.schedule}, {request.theme}"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/chat")
async def chat_page(request: Request, query: str = None):
    """
    챗봇 페이지 렌더링
    - 자연어 쿼리를 받아 응답 제공
    """
    if not query:
        return templates.TemplateResponse("index2.html", {
            "request": request,
            "query": "",
            "ai_response": "질문을 입력해주세요."
        })
    
    try:
        result = model_service.process_chatbot_query(query)
        recommendations_text = "\n".join([f"- {item}" for item in result["recommendations"]])
        additional_info = result.get("additional_info", "")
        ai_response = f"{recommendations_text}\n\n{additional_info}" if additional_info else recommendations_text
        
        return templates.TemplateResponse("index2.html", {
            "request": request,
            "query": query,
            "ai_response": ai_response
        })
    except Exception as e:
        return templates.TemplateResponse("index2.html", {
            "request": request,
            "query": query,
            "ai_response": f"오류가 발생했습니다: {str(e)}"
        })

@router.post("/chatbot", response_model=TravelRecommendationResponse)
async def chatbot_api(request: ChatbotRequest):
    """
    챗봇 API 엔드포인트
    - 자연어 쿼리를 받아 여행 추천 생성
    - Spring Boot 백엔드와 연동
    """
    try:
        result = model_service.process_chatbot_query(request.query)
        return TravelRecommendationResponse(
            recommendations=result["recommendations"],
            confidence_score=result["confidence_score"],
            additional_info=result.get("additional_info", "")
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/page04/message", response_model=JHResponse)
async def process_jh_message(request: JHRequestDto, chat_service: ChatService = Depends(get_chat_service), qna_service: QnaService = Depends(get_qna_service)):
    """
    Spring Boot 연동용 API 엔드포인트
    - 메시지와 이메일 처리
    - 로그/QNA 업데이트 또는 삽입 (날짜 기반 중복 방지)
    - 모든 로그 및 관련 QNA 반환 (리스트 형태, 이메일 제공 시)
    """
    try:
        message = request.message
        email = request.email

        # 모델 응답 생성
        result = model_service.process_chatbot_query(message)
        recommendations_text = "\\n".join([f"- {item}" for item in result["recommendations"]])
        additional_info = result.get("additional_info", "")
        response_text = f"{recommendations_text}\\n\\n{additional_info}" if additional_info else recommendations_text

        response_data = {"response": response_text}
        processed_chat_log_id = None

        if email:
            try:
                title = result["recommendations"][0] if result["recommendations"] else "일반 대화"

                # Chat Log 처리
                chat_result = chat_service.update_chat_log(email, title)
                if chat_result:
                    processed_chat_log_id = chat_result.get("chat_log_id")

                # QNA 처리
                if processed_chat_log_id:
                    qna_service.create_or_update_qna(
                        chat_log_id=processed_chat_log_id,
                        question=message,
                        answer=response_text
                    )

                # 모든 데이터 조회 및 리스트 생성
                all_chat_logs = chat_service.get_chat_logs_by_email(email)
                all_qna_for_email = qna_service.get_qna_by_email(email)

                if all_chat_logs:
                    response_data["titles"] = [log.get("title") for log in all_chat_logs if log.get("title")]
                    response_data["upt_dates"] = [log.get("upt_date") for log in all_chat_logs if log.get("upt_date")]
                    response_data["chat_logs"] = all_chat_logs

                if all_qna_for_email:
                    response_data["questions"] = [qna.get("question") for qna in all_qna_for_email if qna.get("question")]
                    response_data["answers"] = [qna.get("answer") for qna in all_qna_for_email if qna.get("answer")]

                if processed_chat_log_id:
                    current_qna_data = qna_service.get_qna_by_chat_log_id(processed_chat_log_id)
                    if current_qna_data:
                        response_data["qna_data"] = current_qna_data

            except Exception as e:
                print(f"데이터 처리/조회 실패: {str(e)}")

        return JHResponse(**response_data)

    except Exception as e:
        error_message = f"오류가 발생했습니다: {str(e)}"
        return JHResponse(response=error_message)

@router.post("/page3/message", response_model=JHResponse2)
async def process_jh_message2(request: JHRequestDto2, chat_service: ChatService = Depends(get_chat_service), qna_service: QnaService = Depends(get_qna_service)):
    """
    Spring Boot 연동용 API 엔드포인트 (위치 정보 포함)
    - 메시지와 이메일 처리
    - 로그/QNA 업데이트 또는 삽입 (날짜 기반 중복 방지, 이메일 제공 시)
    - 모든 로그 및 관련 QNA 반환 (리스트 형태, 이메일 제공 시)
    """
    try:
        message = request.message
        email = request.email

        # 모델 응답 생성 (위치 정보 포함 가능성)
        result = model_service.process_Area_query(message)
        recommendations_text = "\\n".join([f"- {item}" for item in result["recommendations"]])
        additional_info = result.get("additional_info", "")
        response_text = f"{recommendations_text}\\n\\n{additional_info}" if additional_info else recommendations_text

        response_data = {"response": response_text}
        if result.get("latitude"):
            response_data["latitude"] = result["latitude"]
        if result.get("longitude"):
            response_data["longitude"] = result["longitude"]

        processed_chat_log_id = None

        if email:
            try:
                title = result["recommendations"][0] if result["recommendations"] else "일반 대화"

                # Chat Log 처리
                chat_result = chat_service.update_chat_log(email, title)
                if chat_result:
                    processed_chat_log_id = chat_result.get("chat_log_id")

                # QNA 처리
                if processed_chat_log_id:
                    qna_service.create_or_update_qna(
                        chat_log_id=processed_chat_log_id,
                        question=message,
                        answer=response_text
                    )

                # 모든 데이터 조회 및 리스트 생성
                all_chat_logs = chat_service.get_chat_logs_by_email(email)
                all_qna_for_email = qna_service.get_qna_by_email(email)

                if all_chat_logs:
                    response_data["titles"] = [log.get("title") for log in all_chat_logs if log.get("title")]
                    response_data["upt_dates"] = [log.get("upt_date") for log in all_chat_logs if log.get("upt_date")]
                    response_data["chat_logs"] = all_chat_logs

                if all_qna_for_email:
                    response_data["questions"] = [qna.get("question") for qna in all_qna_for_email if qna.get("question")]
                    response_data["answers"] = [qna.get("answer") for qna in all_qna_for_email if qna.get("answer")]

                if processed_chat_log_id:
                    current_qna_data = qna_service.get_qna_by_chat_log_id(processed_chat_log_id)
                    if current_qna_data:
                        response_data["qna_data"] = current_qna_data

            except Exception as e:
                print(f"데이터 처리/조회 실패 (page3): {str(e)}")

        return JHResponse2(**response_data)

    except Exception as e:
        error_message = f"오류가 발생했습니다: {str(e)}"
        return JHResponse2(response=error_message)
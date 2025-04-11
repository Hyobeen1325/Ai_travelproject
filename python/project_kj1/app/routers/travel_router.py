from fastapi import APIRouter, HTTPException, Request
from fastapi.templating import Jinja2Templates
from app.schemas.travel_schema import TravelKeywordRequest, TravelRecommendationResponse, ChatbotRequest, JHRequestDto, JHResponse
from app.services.model_service import TravelModelService

router = APIRouter()
model_service = TravelModelService()
templates = Jinja2Templates(directory="app/templates")

@router.get("/")
async def travel_page(request: Request):
    """메인 여행 추천 페이지 렌더링"""
    return templates.TemplateResponse("index.html", {
        "request": request,
        "username": "사용자",  # 실제로는 로그인된 사용자 이름
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
        # 모델 서비스를 통한 추천 생성
        recommendations, confidence = model_service.get_recommendations(
            location=request.location,
            schedule=request.schedule,
            theme=request.theme
        )
        
        # 응답 생성
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
        # 쿼리가 없는 경우 빈 페이지 렌더링
        return templates.TemplateResponse("index2.html", {
            "request": request,
            "query": "",
            "ai_response": "질문을 입력해주세요."
        })
    
    try:
        # 모델 서비스를 통한 챗봇 응답 생성
        result = model_service.process_chatbot_query(query)
        
        # 추천 목록을 문자열로 변환
        recommendations_text = "\n".join([f"- {item}" for item in result["recommendations"]])
        additional_info = result.get("additional_info", "")
        
        # 응답 생성
        ai_response = f"{recommendations_text}\n\n{additional_info}" if additional_info else recommendations_text
        
        # 페이지 렌더링
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
        # Process the chatbot query using the updated model service
        result = model_service.process_chatbot_query(request.query)

        # 응답 생성
        return TravelRecommendationResponse(
            recommendations=result["recommendations"],
            confidence_score=result["confidence_score"],
            additional_info=result.get("additional_info", "")
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.post("/page04/message", response_model=JHResponse)
async def process_jh_message(request: JHRequestDto):
    """
    Spring Boot 연동용 API 엔드포인트
    - Spring Boot에서 메시지를 받아 처리하고 응답 반환
    """
    try:
        # 사용자 메시지 처리
        message = request.message
        
        # 모델 서비스를 통한 응답 생성
        result = model_service.process_chatbot_query(message)
        
        # 추천 목록을 문자열로 변환
        recommendations_text = "\n".join([f"- {item}" for item in result["recommendations"]])
        additional_info = result.get("additional_info", "")
        
        # 응답 생성
        response_text = f"{recommendations_text}\n\n{additional_info}" if additional_info else recommendations_text
        
        # JH 응답 형식으로 반환
        return JHResponse(response=response_text)
        
    except Exception as e:
        # 오류 발생 시 오류 메시지 반환
        error_message = f"오류가 발생했습니다: {str(e)}"
        return JHResponse(response=error_message) 
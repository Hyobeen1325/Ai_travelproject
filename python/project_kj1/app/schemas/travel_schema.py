from pydantic import BaseModel
from typing import List, Optional, Dict

class TravelKeywordRequest(BaseModel):
    """여행 키워드 요청 스키마"""
    location: str  # 지역 키워드
    schedule: str  # 일정 키워드
    theme: str    # 테마 키워드

class ChatbotRequest(BaseModel):
    """챗봇 질문 요청 스키마"""
    query: str  # 사용자 질문

class JHRequestDto(BaseModel):
    """JH 서비스 요청 스키마 (Spring Boot 연동용)"""
    message: str  # 사용자 메시지
    arealistrq: str # 지역리스트

class JHResponse(BaseModel):
    """JH 서비스 응답 스키마 (Spring Boot 연동용)"""
    response: str  # 응답 메시지
    location: Optional[str] = None  # 위치 정보 (있는 경우)

class TravelRecommendationResponse(BaseModel):
    """여행 추천 응답 스키마"""
    recommendations: List[str]
    confidence_score: float
    additional_info: Optional[str] = None
    location: Optional[str] = None  # 위치 정보 (있는 경우)
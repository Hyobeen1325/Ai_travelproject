from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from app.routers import travel_router
import uvicorn

app = FastAPI(
    title="Travel Recommendation API",
    description="키워드 기반 여행 추천 API",
    version="1.0.0"
)

# CORS 설정 추가
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 실제 배포 시 특정 도메인으로 제한해야 함
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 정적 파일 서빙 설정
app.mount("/static", StaticFiles(directory="app/static"), name="static")

# 라우터 등록
app.include_router(travel_router.router, prefix="/api/v1/travel", tags=["travel"])
app.include_router(travel_router.router, prefix="/api/v1/chatbot", tags=["chatbot"])
app.include_router(travel_router.router, prefix="")  # UI 라우터

@app.get("/")
async def root():
    return {
        "message": "Travel Recommendation API",
        "docs_url": "/docs",
        "chatbot_url": "/chat"
    }

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)

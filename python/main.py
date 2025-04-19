# main.py

# FastAPI
from fastapi import FastAPI
from app.database.database import Base,engine
import uvicorn # server
app = FastAPI()

Base.metadata.create_all(bind=engine)

# 세션 관리
from starlette.middleware.sessions import SessionMiddleware # 세션 관리 미들웨어 
from app.key.secretkey import SESSION_KEY  # 세션 key 정보 
app.add_middleware(SessionMiddleware, secret_key=SESSION_KEY) # 세션 지정 

# router 
from app.routers import member_router,auth_router # member router
app.include_router(member_router.router) 
app.include_router(auth_router.router) 

"""유찬우"""
# 선택값 CRUD 라우터
from app.routers import choose_val_router
from app.database.database import engine, Base

# 데이터베이스 테이블 생성
Base.metadata.create_all(bind=engine)
app.include_router(choose_val_router.choose_router)
"""유찬우 끝"""
"""권정현"""
from app.routers import travel_router
app.include_router(travel_router.router)
"""권정현 끝"""
# FAST 실행명령어 자동 실행 (main 함수)   
# http://127.0.0.1:8000/docs
if __name__ == "__main__":
    uvicorn.run(app="main:app", host="0.0.0.0", port=8000, reload=True)
    # 서버 종료 단축키 : ctrl + c 
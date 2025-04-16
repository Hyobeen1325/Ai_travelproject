# main.py

# FastAPI
from fastapi import FastAPI
import uvicorn # server
app = FastAPI()


# 세션 관리
from starlette.middleware.sessions import SessionMiddleware # 세션 관리 미들웨어 
from app.key.secretkey import SESSION_KEY  # 세션 key 정보 
app.add_middleware(SessionMiddleware, secret_key=SESSION_KEY) # 세션 지정 

# router 
from app.routers import member_router # member router
app.include_router(member_router.router) 


# FAST 실행명령어 자동 실행 (main 함수)   
# http://127.0.0.1:8000/docs
if __name__ == "__main__":
    uvicorn.run(app="main:app", host="0.0.0.0", port=8000, reload=True)
    # 서버 종료 단축키 : ctrl + c 
# main.py
# FastAPI
from fastapi import FastAPI
import uvicorn # server
app = FastAPI()

# router
from app.routers import member_router
# router
app.include_router(member_router.router) # member




# FAST 실행명령어 자동 실행    
# http://127.0.0.1:8000/docs
if __name__ == "__main__":
    uvicorn.run(app="main:app", host="0.0.0.0", port=8000, reload=True)
    # 서버 종료 단축키 : ctrl + c 
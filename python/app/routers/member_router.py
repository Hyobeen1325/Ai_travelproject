# app/routers/member_router.py
from fastapi import APIRouter,  HTTPException, Depends
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session
from app.database.database import get_db
from app.models.sql_member import SQLMember
from app.services.member_service import get_all_members
from app.schema.member import Member, LoginModel, MemberBase

router = APIRouter(
    prefix="/login", # 기본 경로
    tags=["member"] # 제목
)

# 유저 정보 조회
@router.get("/")
def read_member(db: Session = Depends(get_db)):
    return get_all_members(db)

# 로그인
@router.post("/member", response_model=MemberBase)
def login(request: LoginModel, db: Session = Depends(get_db)): 
    # user 정보 조회(아이디, 비밀번호)
    user = db.query(SQLMember).filter(SQLMember.email == request.email).first()
    
    # 입력값과 db 데이터 유효성 검사
    if not user or user.pwd != request.pwd: # 로그인 실패
        raise HTTPException(status_code=400, detail="아이디 또는 비밀번호가 올바르지 않습니다.") 
    
    # 로그인 성공 응답
    return MemberBase(
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        pwd=user.pwd,
        phon_num=user.phon_num,
        reg_date=user.reg_date,
        upt_date=user.upt_date
    )

# 로그아웃 
@router.post("/logout")
def logout(): # 로그아웃 성공
    return JSONResponse(status_code=200, content={"msg":"로그아웃 성공!"})
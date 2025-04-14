# app/routers/member_router.py
from fastapi import APIRouter,  HTTPException, Depends
from sqlalchemy.orm import Session
from app.database.database import get_db
from app.models.sql_member import SQLMember
from app.services.member_service import get_all_members
from app.schema.member import Member, LoginModel

router = APIRouter(
    prefix="/member", 
    tags=["member"]
)

# 조회
@router.get("/", response_model=list[Member])
def read_members(db: Session = Depends(get_db)):
    return get_all_members(db)

# 로그인
@router.post("/login")
def login(request: LoginModel, db: Session = Depends(get_db)):
    # 사용자 정보 유효성 검사
    user = db.query(SQLMember).filter(SQLMember.email == request.email).first()
    if not user or user.pwd != request.pwd:
        raise HTTPException(status_code=400, detail="아이디 또는 비밀번호가 틀립니다.")
    return {"message": "로그인 성공!", "email": user.email} # 로그인 성공시 사용자 이름 반환
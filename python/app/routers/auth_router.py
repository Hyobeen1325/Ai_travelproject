from fastapi import APIRouter, HTTPException, Depends, Request # 라우터 처리, 예외 처리, 의존성 주입
from sqlalchemy.orm import Session # SQLAlchemy 세션
from app.database.database import get_db # DB 연결
from app.models.sql_member import SQLMember # SQLAlchemy 모델
from app.services.member_service import get_all_members # 유저 정보 조회
from app.schema.member import MemberCreate # DTO

router = APIRouter(prefix="/auth", tags=["auth"])

@router.post("/register", response_model=MemberCreate)
async def register_user(user: MemberCreate, db: Session = Depends(get_db)):
    db_user = db.query(SQLMember).filter(SQLMember.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="이미 존재하는 이메일입니다.")
    db_nickname = db.query(SQLMember).filter(SQLMember.nickname == user.nickname).first()
    if db_nickname:
        raise HTTPException(status_code=400, detail="이미 존재하는 닉네임입니다.")

    db_user = MemberCreate(
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        password=user.password,  # Spring Security에서 암호화 예정
        phone_number=user.phone_number,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
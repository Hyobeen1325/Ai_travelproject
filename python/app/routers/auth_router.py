from fastapi import APIRouter, HTTPException, Depends, Request # 라우터 처리, 예외 처리, 의존성 주입
from sqlalchemy.orm import Session # SQLAlchemy 세션
from app.database.database import get_db # DB 연결
from app.models.sql_member import SQLMember # SQLAlchemy 모델
from app.services.member_service import get_all_members # 유저 정보 조회
from app.schema.member import MemberCreate,Member # DTO
from datetime import datetime # reg_date, upt_date를 위해서 import

router = APIRouter(prefix="/auth", tags=["auth"])
#회원가입
@router.post("/register", response_model=Member)
async def register_user(user: MemberCreate, db: Session = Depends(get_db)):
    db_user = db.query(SQLMember).filter(SQLMember.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="이미 존재하는 이메일입니다.")
    db_nickname = db.query(SQLMember).filter(SQLMember.nickname == user.nickname).first()
    if db_nickname:
        raise HTTPException(status_code=400, detail="이미 존재하는 닉네임입니다.")

    # 1. SQLMember 모델 인스턴스 생성 및 데이터 할당
    db_member = SQLMember(
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        pwd=user.pwd,
        phon_num=user.phon_num,
        # reg_date=datetime.now(), # 현재 시각으로 설정
        # upt_date=datetime.now()  # 현재 시각으로 설정
    )

    # 2. 세션에 추가
    db.add(db_member)
    # 3. 변경 사항 커밋 (데이터베이스에 저장)
    db.commit()
    # 4. 세션 갱신 (저장된 데이터 반영, 특히 id 값)
    db.refresh(db_member)

    return db_member
    
    
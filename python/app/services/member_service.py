# app/services/member_service.py
from sqlalchemy.orm import Session # 세션 관리
from app.models.sql_member import SQLMember # SQLAlchemy 모델

def get_all_members(db: Session): # member 테이블 조회
    return db.query(SQLMember).all() # 모든 member 데이터 반환
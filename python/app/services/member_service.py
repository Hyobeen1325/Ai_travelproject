# app/services/member_service.py
from sqlalchemy.orm import Session
from app.models.sql_member import SQLMember

def get_all_members(db: Session):
    return db.query(SQLMember).all()
from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class ChatLogCreate(BaseModel):
    """채팅 로그 생성 스키마"""
    mem_email: str
    mem_log_id: str
    title: str
    reg_date: datetime
    upt_date: datetime

class ChatLogUpdate(BaseModel):
    """채팅 로그 업데이트 스키마"""
    new_mem_log_id: str
    title: str

class ChatLogResponse(BaseModel):
    """채팅 로그 응답 스키마"""
    reg_date: datetime
    title: str 
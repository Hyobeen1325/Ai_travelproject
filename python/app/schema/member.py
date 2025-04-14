# app/schema/member.py
from pydantic import BaseModel
from datetime import datetime

class MemberBase(BaseModel):  # user
    email: str # 이메일(아이디)
    name: str # 이름
    nickname: str # 닉네임
    pwd: str # 비밀번호(password)
    phon_num: str  # 전화번호
    reg_data: datetime = datetime.now()  # 생성일 
    upt_data: datetime = datetime.now()  # 수정일 

class LoginModel(BaseModel):
    email: str
    pwd: str

class Member(MemberBase):
    class Config:
        orm_mode = True
from pydantic import BaseModel
from datetime import datetime

# 선택값 리퀘스트
class ChooseValCreate(BaseModel):
    high_loc: str
    chat_log_id: str
    low_loc: str
    theme1: str
    theme2: str
    theme3: str
    theme4: str
    days: int

# 선택값 리스폰스
class ChooseValResponse(ChooseValCreate):
    choose_id: int
    regdate: datetime
    uptdate: datetime

    class Config:
        orm_mode = True # SQLAlchemy로 생성된 데이터를 담을 수 있게 됨

# 지역리스트 리퀘스트
class AreaListCreate(BaseModel):
    chat_log_id: str
    title: str
    mapx: float
    mapy: float
    contenttypeid: str
    firstimage: str
    firstimage2: str
    tel: str
    addr1: str
    addr2: str

# 지역리스트 리스폰스
class AreaListResponse(AreaListCreate):
    area_list_id: int
    regdate: datetime
    uptdate: datetime
    
    class Config:
        orm_mode = True
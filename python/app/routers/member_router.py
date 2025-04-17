# app/routers/member_router.py
from fastapi import APIRouter, HTTPException, Depends, Request # 라우터 처리, 예외 처리, 의존성 주입
from sqlalchemy.orm import Session # SQLAlchemy 세션
from app.database.database import get_db # DB 연결
from app.models.sql_member import SQLMember # SQLAlchemy 모델
from app.services.member_service import get_all_members # 유저 정보 조회
from app.schema.member import LoginModel, MemberBase, MypageModel, UpdateModel # DTO


router = APIRouter(
    prefix="/login", # 클래스 공통 경로
    tags=["member"] # 제목
)

# 유저 정보 조회 = 테스트용
@router.get("/")
def read_member(db: Session=Depends(get_db)):
    return get_all_members(db)

# 로그인
@router.post("/member", response_model=MemberBase)
def login(request: Request, data: LoginModel, db: Session=Depends(get_db)): 
    # user 정보 조회(아이디, 비밀번호)
    user = db.query(SQLMember).filter(SQLMember.email == data.email).first()
    
    # 입력값과 db 데이터 유효성 검사
    if not user or user.pwd != data.pwd: # 로그인 실패
        raise HTTPException(status_code=400, detail="아이디 또는 비밀번호가 올바르지 않습니다.") 
    
    # 이메일 세션 처리 
    request.session["user_email"] = user.email
     # 응답 데이터 반환
    return MemberBase( # 응답 데이터
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        pwd=user.pwd,
        phon_num=user.phon_num,
        reg_date=user.reg_date,
        upt_date=user.upt_date,
    )

# 로그아웃 
@router.post("/logout")
def logout(request: Request):
    request.session.clear()  # 세션 초기화
    return {"msg": "로그아웃 성공!"}


# 마이페이지 
# 내정보 조회
@router.get("/mypage/{email}", response_model=MypageModel) # SQLMember
def read_mypage(email: str, request: Request, db: Session=Depends(get_db)):
    
    # 이메일 세션 처리
    user_email = request.session.get("user_email")
    
    # 세션 유지x
    if not user_email or user_email != email:
        raise HTTPException(status_code=401, detail="로그인이 필요합니다.")
    
    # member 정보 조회 
    user =  db.query(SQLMember).filter(SQLMember.email == email).first() # 이메일로 member 조회
    if not user:
        raise HTTPException(status_code=404, detail="존재하지 않는 회원정보입니다.") # 예외 처리
    
    return MypageModel( # 응답 데이터
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        phon_num=user.phon_num
    )

# 내정보 수정   
@router.put("/mypage/{email}") # 일부만 수정
def update_mypage(email: str, request: Request, data: UpdateModel, db: Session=Depends(get_db)):
    
    # 이메일 세션 처리
    user_email = request.session.get("user_email")
    # 세션 유지x
    if not user_email or user_email != email:
        raise HTTPException(status_code=401, detail="로그인이 필요합니다.")
    
    # member 정보 조회 
    user =  db.query(SQLMember).filter(SQLMember.email == email).first() # 이메일로 member 조회
    # 예외 처리
    if not user: 
        raise HTTPException(status_code=404, detail="존재하지 않는 회원정보입니다.")
    
    # 입력값과 db 데이터 유효성 검사
    # data : 입력값, user : db 저장값
    if data.nickname:  
        user.nickname = data.nickname 
    if data.phon_num:
        user.phon_num = data.phon_num
    
    db.commit() # db에 저장
    db.refresh(user) # 새로고침
    
    # 응답 데이터
    return MypageModel( # 수정값 MypageModel에게 반환
        email=user.email,
        nickname=user.nickname,
        phon_num=user.phon_num,
    )
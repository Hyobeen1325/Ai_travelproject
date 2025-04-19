from fastapi import APIRouter, HTTPException, Depends, Request # 라우터 처리, 예외 처리, 의존성 주입
from sqlalchemy.orm import Session # SQLAlchemy 세션
from app.database.database import get_db # DB 연결
from app.services import member_service # member service
from app.schema.member import LoginModel, MemberBase, MypageModel, UpdateModel, UpdatePwd # DTO

router = APIRouter(
    prefix="/login", # 클래스 공통 경로
    tags=["member"] # 제목
)

# 로그인 유효성 검사
@router.post("/member", response_model=MemberBase)
def login(request: Request, data: LoginModel, db: Session=Depends(get_db)):
    # memeber 아이디와 비밀번호 조회
    user = member_service.get_member_by_email(db, data.email)

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
    request.session.clear() # 세션 무효화(삭제)
    return {"msg": "로그아웃 성공!"}


# 마이페이지
# 내정보 조회
@router.get("/mypage/{email}", response_model=MypageModel) 
def read_mypage(email: str, request: Request, db: Session=Depends(get_db)):
    # 이메일 세션 처리
    user_email = request.session.get("user_email")
    # 세션 유지x
    if not user_email or user_email != email:
        raise HTTPException(status_code=401, detail="로그인이 필요합니다.")

    # member 정보 조회
    user =  member_service.get_member_by_email(db, email) # 이메일로 member 조회
    if not user:
        raise HTTPException(status_code=404, detail="존재하지 않는 회원입니다.") # 예외 처리

    # 응답 데이터 반환
    return MypageModel( # 응답 데이터
        email=user.email,
        name=user.name,
        nickname=user.nickname,
        phon_num=user.phon_num
    )

# 내정보 수정
@router.put("/mypage/{email}", response_model=MypageModel) # 일부만 수정
def update_mypage(email: str, data: UpdateModel, db: Session=Depends(get_db)):
        # member 정보 조회
        user =  member_service.get_member_by_email(db, email) # 이메일로 member 조회
        if not user: # 예외 처리
            raise HTTPException(status_code=404, detail="존재하지 않는 회원입니다.")

        # 이메일 중복 검사
        if data.email:
            exist_user = member_service.get_member_by_email(db, data.email) # 유효성 검사
            if exist_user and exist_user.email != email: # 예외 처리
                raise HTTPException(status_code=400, detail="이미 사용 중인 이메일입니다.")

        updated_user = member_service.update_member(db, email, data)
        if updated_user:
            # 응답 데이터
            return MypageModel( # 수정 데이터 MypageModel에 반환
                email=updated_user.email,
                name=updated_user.name,
                nickname=updated_user.nickname,
                phon_num=updated_user.phon_num,
            )
            
        raise HTTPException(status_code=500, detail="내정보 수정 실패") # 예외 처리

# 비밀번호 변경
@router.put("/mypage/{email}/pwd", response_model=MypageModel) # 비밀번호만 변경
def update_pwd(email: str, data: UpdatePwd, db: Session=Depends(get_db)):
    # member 정보 조회
    user = member_service.get_member_by_email(db, email) # 이메일로 member 조회
    if not user: # 예외 처리
        raise HTTPException(status_code=404, detail="존재하지 않는 회원입니다.")

    updated_user = member_service.update_member_password(db, email, data)
    if updated_user:
        # 응답 데이터
        return MypageModel(
            email=updated_user.email,
            name=updated_user.name,
            nickname=updated_user.nickname,
            phon_num=updated_user.phon_num,
        )
        
    raise HTTPException(status_code=400, detail="비밀번호 변경 실패")  # 예외 처리
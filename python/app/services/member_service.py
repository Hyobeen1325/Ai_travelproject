from sqlalchemy.orm import Session # SQLAlchemy 세션 관리
from app.models.sql_member import SQLMember # SQLAlchemy 모델
from app.schema.member import UpdateModel, UpdatePwd # schema : DTO
from fastapi import HTTPException # 예외 처리

# 유효성 검사
# 로그인(이름, 닉네임, 전화번호, 아이디), 내정보 조회  
def get_member_by_email(db: Session, email: str): # 이메일로 회원정보 조회
    return db.query(SQLMember).filter(SQLMember.email == email).first() # db 조회

# 마이페이지 
# 내정보 수정 (이메일, 닉네임, 전화번호)
def update_member(db: Session, email: str, update_data: UpdateModel): # 이메일로 내정보 업데이트
    db_member = get_member_by_email(db, email) # db로 member 조회 
    if db_member: 
        if update_data.email: # 이메일 
            db_member.email = update_data.email  # db에 수정된 데이터 업데이트 
        if update_data.nickname is not None: # 닉네임 
            db_member.nickname = update_data.nickname
        if update_data.phon_num is not None: # 전화번호 
            db_member.phon_num = update_data.phon_num
        db.commit() # db에 커밋
        db.refresh(db_member) # db에 반영
        return db_member # 수정된 데이터 반환 
    return None # 수정된 데이터가 없는 경우, None 반환

# 비밀번호 변경
def update_member_password(db: Session, email: str, update_pwd: UpdatePwd): # 이메일로 비밀번호 업데이트
    db_member = get_member_by_email(db, email)  # db로 member 조회 
    if db_member: 
        if db_member.pwd == update_pwd.pwd: # 현재 비밀번호 확인
            if update_pwd.new_pwd: # 새 비밀번호 확인 
                db_member.pwd = update_pwd.new_pwd # db에 수정된 데이터 업데이트
                db.commit() # db에 커밋
                db.refresh(db_member) # db에 반영
                return db_member # 수정된 데이터 반환
            else: # 기존 비밀번호와 새 비밀번호 텍스트가 같은 내용인 경우
                raise HTTPException(status_code=400, detail="새 비밀번호를 입력해주세요.")
        else: # 일치하지 않은 경우 
            raise HTTPException(status_code=400, detail="현재 비밀번호가 일치하지 않습니다.")
    return None # 수정된 데이터가 없는 경우, None 반환
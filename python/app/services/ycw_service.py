from datetime import datetime
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError
from app.schema.ycw_schema import ChooseValCreate
from fastapi import HTTPException
from app.models.ycw_models import Choose_val_Model

# 선택값 CRUD 클래스
class Choose_val_service:
    # 생성
    def create_choose_val(db: Session, choose_val: ChooseValCreate):
        try:
            db_choose_val = Choose_val_Model(
                high_loc=choose_val.high_loc,
                low_loc=choose_val.low_loc,
                theme1=choose_val.theme1,
                theme2=choose_val.theme2,
                theme3=choose_val.theme3,
                theme4=choose_val.theme4,
                days=choose_val.days)
            db.add(db_choose_val)
            db.commit()
            db.refresh(db_choose_val)
            return db_choose_val
        except SQLAlchemyError as e:
            db.rollback()  # 실패 시 rollback 필수!
            raise HTTPException(status_code=500, detail=f"등록 중 오류 발생: {str(e)}")
        
    # 전체 조회
    def get_all_choose_vals(db: Session):
        return db.query(Choose_val_Model).all()

    # 단일 조회
    def get_choose_val_by_id(db: Session, choose_id: int):
        choose_val = db.query(Choose_val_Model).filter(Choose_val_Model.choose_id == choose_id).first()
        if choose_val is None:
            raise HTTPException(status_code=404, detail="Choose_val not found")
        return choose_val

    # 수정
    def update_choose_val(db: Session, choose_id: int, updated_data: ChooseValCreate):
        try:
            choose_val = db.query(Choose_val_Model).filter(Choose_val_Model.choose_id == choose_id).first()
            if choose_val is None:
                raise HTTPException(status_code=404, detail="Choose_val not found")

            choose_val.high_loc = updated_data.high_loc
            choose_val.low_loc = updated_data.low_loc
            choose_val.theme1 = updated_data.theme1
            choose_val.theme2 = updated_data.theme2
            choose_val.theme3 = updated_data.theme3
            choose_val.theme4 = updated_data.theme4
            choose_val.days = updated_data.days
            choose_val.uptdate = datetime.now()

            db.commit()
            db.refresh(choose_val)
            return choose_val
        except SQLAlchemyError as e:
            db.rollback()
            raise HTTPException(status_code=500, detail=f"수정 중 오류 발생: {str(e)}")

    # 삭제
    def delete_choose_val(db: Session, choose_id: int):
        try:
            choose_val = db.query(Choose_val_Model).filter(Choose_val_Model.choose_id == choose_id).first()
            if choose_val is None:
                raise HTTPException(status_code=404, detail="Choose_val not found")

            db.delete(choose_val)
            db.commit()
            return {"message": f"Choose_val with id {choose_id} has been deleted"}
        except SQLAlchemyError as e:
            db.rollback()
            raise HTTPException(status_code=500, detail=f"삭제 중 오류 발생: {str(e)}")
# app/services/chat_service.py
from datetime import date
from typing import Optional, Dict, Any, List
from sqlalchemy.orm import Session
from app.models.kjh_models import ChatLog

class ChatService:
    def __init__(self, db: Session):
        self.db = db

    def update_chat_log(self, mem_email: str, title: str) -> Optional[Dict[str, Any]]:
        """기존 로그 확인 후 업데이트 또는 삽입. 같은 날 같은 제목은 무시."""
        try:
            current_date = date.today()
            
            # 1. 같은 이메일, 같은 제목의 가장 최근 로그 조회
            existing_log = self.db.query(ChatLog).filter(
                ChatLog.mem_email == mem_email,
                ChatLog.title == title
            ).order_by(ChatLog.upt_date.desc()).first()
            
            # 2. 로직 분기
            if existing_log:
                existing_upt_date = existing_log.upt_date
                if current_date == existing_upt_date:
                    # 같은 날 같은 제목: 아무 작업 안함, 기존 정보 반환
                    return {
                        "chat_log_id": existing_log.chat_log_id,
                        "title": title,
                        "upt_date": existing_upt_date.strftime("%Y-%m-%d")
                    }
                else:
                    # 다른 날 같은 제목: upt_date만 갱신
                    existing_log.upt_date = current_date
                    self.db.commit()
                    return {
                        "chat_log_id": existing_log.chat_log_id,
                        "title": title,
                        "upt_date": current_date.strftime("%Y-%m-%d")
                    }
            else:
                # 새로운 제목: 신규 삽입 (최신 chat_log_id 확인 후 순차적으로 생성)
                last_log = self.db.query(ChatLog.chat_log_id).order_by(ChatLog.chat_log_id.desc()).first()

                if last_log and last_log.chat_log_id.startswith('a'):
                    last_chat_log_id = last_log.chat_log_id
                    try:
                        last_id_num = int(last_chat_log_id[1:])
                        new_id_num = last_id_num + 1
                        new_chat_log_id = f"a{new_id_num:04d}"
                    except ValueError:
                        new_chat_log_id = 'a0001' # 파싱 오류 시 초기값으로 설정
                else:
                    new_chat_log_id = 'a0001'

                new_log = ChatLog(
                    chat_log_id=new_chat_log_id,
                    mem_email=mem_email,
                    title=title,
                    reg_date=current_date,
                    upt_date=current_date
                )
                self.db.add(new_log)
                self.db.commit()
                return {
                    "chat_log_id": new_chat_log_id,
                    "title": title,
                    "upt_date": current_date.strftime("%Y-%m-%d")
                }

        except Exception as e:
            self.db.rollback()
            print(f"Error in update_chat_log: {e}")
            raise e
        
    def get_chat_logs_by_email(self, mem_email: str) -> List[Dict[str, Any]]:
        """특정 이메일의 모든 채팅 로그 가져오기"""
        try:
            results = self.db.query(ChatLog).filter(ChatLog.mem_email == mem_email).order_by(ChatLog.reg_date.desc()).all()
            
            # 날짜 객체를 "YYYY-MM-DD" 문자열로 변환
            formatted_results = []
            for log in results:
                formatted_row = {
                    "chat_log_id": log.chat_log_id,
                    "mem_email": log.mem_email,
                    "title": log.title,
                    "reg_date": log.reg_date.strftime("%Y-%m-%d") if log.reg_date else None,
                    "upt_date": log.upt_date.strftime("%Y-%m-%d") if log.upt_date else None
                }
                formatted_results.append(formatted_row)
                
            return formatted_results
            
        except Exception as e:
            print(f"Error getting chat logs: {e}")
            return []
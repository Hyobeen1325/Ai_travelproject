# app/services/chat_service.py
from datetime import date
from typing import Optional, Dict, Any, List
from sqlalchemy.orm import Session
from app.models.kjh_models import ChatLog

class ChatService:
    def __init__(self, db: Session):
        self.db = db

    def update_chat_log(self, mem_email: str, answer: str) -> Optional[Dict[str, Any]]:
        """
        답변 내용(answer)을 기반으로 chat_log title을 자동 생성하여 삽입 또는 업데이트
        - 같은 날, 같은 title이면 무시
        - title은 answer의 앞 100자 사용
        """
        try:
            current_date = date.today()

            # 1. 답변으로부터 title 생성 (100자 제한)
            if answer:
                trimmed_title = answer.strip().replace("\n", " ")[:100]
            else:
                trimmed_title = "No Title"

            # 2. 기존 로그 확인
            existing_log = self.db.query(ChatLog).filter(
                ChatLog.mem_email == mem_email,
                ChatLog.title == trimmed_title
            ).order_by(ChatLog.upt_date.desc()).first()

            if existing_log:
                existing_upt_date = existing_log.upt_date
                if current_date == existing_upt_date:
                    # 같은 날, 같은 제목: 업데이트 없이 반환
                    return {
                        "chat_log_id": existing_log.chat_log_id,
                        "title": trimmed_title,
                        "upt_date": existing_upt_date.strftime("%Y-%m-%d")
                    }
                else:
                    # 날짜만 갱신
                    existing_log.upt_date = current_date
                    self.db.commit()
                    return {
                        "chat_log_id": existing_log.chat_log_id,
                        "title": trimmed_title,
                        "upt_date": current_date.strftime("%Y-%m-%d")
                    }
            else:
                # 새로운 title이면 새 로그 생성
                last_log = self.db.query(ChatLog.chat_log_id).order_by(ChatLog.chat_log_id.desc()).first()

                if last_log and last_log.chat_log_id.startswith('a'):
                    try:
                        last_id_num = int(last_log.chat_log_id[1:])
                        new_id_num = last_id_num + 1
                        new_chat_log_id = f"a{new_id_num:04d}"
                    except ValueError:
                        new_chat_log_id = 'a0001'
                else:
                    new_chat_log_id = 'a0001'

                new_log = ChatLog(
                    chat_log_id=new_chat_log_id,
                    mem_email=mem_email,
                    title=trimmed_title,
                    reg_date=current_date,
                    upt_date=current_date
                )
                self.db.add(new_log)
                self.db.commit()
                return {
                    "chat_log_id": new_chat_log_id,
                    "title": trimmed_title,
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
    def get_latest_chat_log_by_email(self, email: str) -> Optional[Dict[str, Any]]:
        try:
            log = self.db.query(ChatLog).filter(
                ChatLog.mem_email == email
            ).order_by(ChatLog.chat_log_id.desc()).first()

            if log:
                return {
                    "chat_log_id": log.chat_log_id,
                    "title": log.title,
                    "upt_date": log.upt_date.strftime("%Y-%m-%d")
                }

            return None

        except Exception as e:
            print(f"get_latest_chat_log_by_email Error: {e}")
            return None
    def get_chat_log_by_id(self, chat_log_id: str) -> Dict:
        return self.db.query(ChatLog).filter(ChatLog.chat_log_id == chat_log_id).first().to_dict()

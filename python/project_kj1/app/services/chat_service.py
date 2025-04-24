from datetime import datetime, date
import pymysql
from typing import Optional, Dict, Any
from sqlalchemy.orm import Session
from sqlalchemy.exc import SQLAlchemyError

class ChatService:
    def __init__(self):
        self.conn = pymysql.connect(
            host='192.168.0.46',
            user='4team',
            password='4444',
            db='sodam',
            charset='utf8mb4'
        )
        self.cursor = self.conn.cursor(pymysql.cursors.DictCursor)

    def update_chat_log(self, mem_email: str, title: str) -> Optional[Dict[str, Any]]:
        """기존 로그 확인 후 업데이트 또는 삽입. 같은 날 같은 제목은 무시."""
        try:
            current_date = date.today()
            
            # 1. 같은 이메일, 같은 제목의 가장 최근 로그 조회
            self.cursor.execute("""
                SELECT chat_log_id, reg_date, upt_date 
                FROM chat_log 
                WHERE mem_email = %s AND title = %s 
                ORDER BY upt_date DESC 
                LIMIT 1
            """, (mem_email, title))
            existing_log = self.cursor.fetchone()
            
            # 2. 로직 분기
            if existing_log:
                existing_upt_date = existing_log['upt_date']
                # DB 컬럼 타입이 DATE 또는 DATETIME인지 확인 필요
                if isinstance(existing_upt_date, datetime):
                    existing_upt_date = existing_upt_date.date()
                
                if current_date == existing_upt_date:
                    # 같은 날 같은 제목: 아무 작업 안함, 기존 정보 반환
                    return {
                        "chat_log_id": existing_log['chat_log_id'],
                        "title": title,
                        "upt_date": existing_upt_date # 기존 upt_date
                    }
                else:
                    # 다른 날 같은 제목: upt_date만 갱신
                    self.cursor.execute("""
                        UPDATE chat_log SET upt_date = %s 
                        WHERE chat_log_id = %s
                    """, (current_date, existing_log['chat_log_id']))
                    self.conn.commit()
                    return {
                        "chat_log_id": existing_log['chat_log_id'],
                        "title": title,
                        "upt_date": current_date # 갱신된 upt_date
                    }
            else:
                # 새로운 제목: 신규 삽입 (a0001/a0002 로직 포함)
                self.cursor.execute(
                    "SELECT chat_log_id FROM chat_log WHERE mem_email = %s ORDER BY reg_date DESC LIMIT 1",
                    (mem_email,)
                )
                last_log = self.cursor.fetchone()
                
                if last_log and last_log['chat_log_id'] == 'a0001':
                    new_chat_log_id_value = 'a0002'
                else:
                    new_chat_log_id_value = 'a0001'
                
                self.cursor.execute("""
                    INSERT INTO chat_log (mem_email, chat_log_id, title, reg_date, upt_date)
                    VALUES (%s, %s, %s, %s, %s)
                """, (mem_email, new_chat_log_id_value, title, current_date, current_date))
                self.conn.commit()
                return {
                    "chat_log_id": new_chat_log_id_value,
                    "title": title,
                    "upt_date": current_date # 새로 삽입된 날짜
                }

        except Exception as e:
            self.conn.rollback()
            print(f"Error in update_chat_log: {e}") # 에러 로깅 추가
            raise e # 에러를 다시 발생시켜 router에서 처리하도록 함
        
    def get_chat_logs_by_email(self, mem_email: str) -> list:
        """특정 이메일의 모든 채팅 로그 가져오기"""
        try:
            self.cursor.execute("""
                SELECT chat_log_id, mem_email, title, 
                       reg_date, upt_date
                FROM chat_log 
                WHERE mem_email = %s
                ORDER BY reg_date DESC
            """, (mem_email,))
            
            results = self.cursor.fetchall()
            
            # 날짜 객체를 "YYYY-MM-DD" 문자열로 변환
            formatted_results = []
            for row in results:
                formatted_row = dict(row)
                if 'reg_date' in formatted_row and formatted_row['reg_date']:
                    # DB에서 DATE 타입으로 읽었을 경우 date 객체, DATETIME이면 datetime 객체일 수 있음
                    if isinstance(formatted_row['reg_date'], datetime):
                        formatted_row['reg_date'] = formatted_row['reg_date'].strftime("%Y-%m-%d")
                    elif isinstance(formatted_row['reg_date'], date):
                         formatted_row['reg_date'] = formatted_row['reg_date'].strftime("%Y-%m-%d")
                if 'upt_date' in formatted_row and formatted_row['upt_date']:
                    if isinstance(formatted_row['upt_date'], datetime):
                        formatted_row['upt_date'] = formatted_row['upt_date'].strftime("%Y-%m-%d")
                    elif isinstance(formatted_row['upt_date'], date):
                        formatted_row['upt_date'] = formatted_row['upt_date'].strftime("%Y-%m-%d")
                formatted_results.append(formatted_row)
                
            return formatted_results
            
        except Exception as e:
            print(f"Error getting chat logs: {e}")
            return []

    def __del__(self):
        try:
            if hasattr(self, 'cursor') and self.cursor:
                self.cursor.close()
            if hasattr(self, 'conn') and self.conn:
                self.conn.close()
        except Exception as e:
            print(f"Error closing resources: {e}")

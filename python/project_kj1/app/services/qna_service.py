from datetime import datetime, date
import pymysql
from typing import Dict, Any, Optional

class QnaService:
    def __init__(self):
        self.conn = pymysql.connect(
            host='192.168.0.46',
            user='4team',
            password='4444',
            db='sodam',
            charset='utf8mb4'
        )
        self.cursor = self.conn.cursor(pymysql.cursors.DictCursor)

    def create_or_update_qna(self, chat_log_id: str, question: str, answer: str) -> Dict[str, Any]:
        """기존 QNA 확인 후 업데이트 또는 삽입. 같은 날 같은 내용은 무시."""
        try:
            current_date = date.today()
            
            # 1. 같은 chat_log_id, question, answer의 가장 최근 QNA 조회
            self.cursor.execute("""
                SELECT qna_id, reg_date, upt_date
                FROM qna
                WHERE chat_log_id = %s AND question = %s AND answer = %s
                ORDER BY upt_date DESC
                LIMIT 1
            """, (chat_log_id, question, answer))
            existing_qna = self.cursor.fetchone()
            
            # 2. 로직 분기
            if existing_qna:
                existing_upt_date = existing_qna['upt_date']
                if isinstance(existing_upt_date, datetime):
                    existing_upt_date = existing_upt_date.date()
                
                if current_date == existing_upt_date:
                    # 같은 날 같은 내용: 아무 작업 안함, 기존 정보 반환
                    return {
                        "qna_id": existing_qna['qna_id'],
                        "question": question,
                        "answer": answer,
                        "upt_date": existing_upt_date
                    }
                else:
                    # 다른 날 같은 내용: upt_date만 갱신
                    self.cursor.execute("""
                        UPDATE qna SET upt_date = %s
                        WHERE qna_id = %s
                    """, (current_date, existing_qna['qna_id']))
                    self.conn.commit()
                    return {
                        "qna_id": existing_qna['qna_id'], # 기존 ID
                        "question": question,
                        "answer": answer,
                        "upt_date": current_date # 갱신된 upt_date
                    }
            else:
                # 새로운 내용: 신규 삽입 (b001 로직 포함)
                self.cursor.execute(
                    "SELECT qna_id FROM qna ORDER BY reg_date DESC LIMIT 1"
                )
                last_qna = self.cursor.fetchone()
                
                if last_qna:
                    current_num = int(last_qna['qna_id'].replace('b', ''))
                    new_qna_id = f'b{str(current_num + 1).zfill(3)}'
                else:
                    new_qna_id = 'b001'
                
                self.cursor.execute("""
                    INSERT INTO qna (chat_log_id, qna_id, question, answer, reg_date, upt_date)
                    VALUES (%s, %s, %s, %s, %s, %s)
                """, (chat_log_id, new_qna_id, question, answer, current_date, current_date))
                self.conn.commit()
                return {
                    "qna_id": new_qna_id,
                    "question": question,
                    "answer": answer,
                    "upt_date": current_date # 새로 삽입된 날짜
                }

        except Exception as e:
            self.conn.rollback()
            print(f"Error in create_or_update_qna: {e}")
            raise e
        
    def __del__(self):
        try:
            if hasattr(self, 'cursor') and self.cursor:
                self.cursor.close()
            if hasattr(self, 'conn') and self.conn:
                self.conn.close()
        except Exception as e:
            print(f"Error closing resources: {e}")

    def get_qna_by_chat_log_id(self, chat_log_id: str) -> list:
        """특정 chat_log_id에 해당하는 모든 QNA 데이터 가져오기"""
        try:
            self.cursor.execute("""
                SELECT chat_log_id, qna_id, question, answer, 
                       reg_date, upt_date
                FROM qna 
                WHERE chat_log_id = %s
                ORDER BY reg_date DESC
            """, (chat_log_id,))
            
            results = self.cursor.fetchall()
            
            # 날짜 객체를 "YYYY-MM-DD" 문자열로 변환
            formatted_results = []
            for row in results:
                formatted_row = dict(row)
                if 'reg_date' in formatted_row and formatted_row['reg_date']:
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
            print(f"Error getting QNA data: {e}")
            return [] 

    def get_qna_by_email(self, mem_email: str) -> list:
        """특정 이메일에 해당하는 모든 QNA 데이터 가져오기 (chat_log 테이블 JOIN)"""
        try:
            self.cursor.execute("""
                SELECT q.chat_log_id, q.qna_id, q.question, q.answer,
                       q.reg_date, q.upt_date
                FROM qna q
                JOIN chat_log cl ON q.chat_log_id = cl.chat_log_id
                WHERE cl.mem_email = %s
                ORDER BY q.reg_date DESC
            """, (mem_email,))

            results = self.cursor.fetchall()

            # 날짜 객체를 "YYYY-MM-DD" 문자열로 변환
            formatted_results = []
            for row in results:
                formatted_row = dict(row)
                if 'reg_date' in formatted_row and formatted_row['reg_date']:
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
            print(f"Error getting QNA data by email: {e}")
            return [] 
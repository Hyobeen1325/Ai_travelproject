package com.example.demo.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data // Getter, Setter, toString, equals, hashCode 자동 생성
@NoArgsConstructor // 기본 생성자
@AllArgsConstructor // 모든 필드 생성자
public class ChatLogItemDto {

    private String chatLogId;    // FastAPI의 chat_log_id
    private String memEmail;     // FastAPI의 mem_email
    private String memLogId;     // FastAPI의 mem_log_id
    private String title;        // FastAPI의 title
    private String regDate;      // FastAPI의 reg_date (이미 문자열로 변환됨)
    private String uptDate;      // FastAPI의 upt_date (이미 문자열로 변환됨)
}
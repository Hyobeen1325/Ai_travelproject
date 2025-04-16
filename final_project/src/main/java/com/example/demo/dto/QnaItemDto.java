package com.example.demo.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QnaItemDto {

    private String chatLogId;    // FastAPI의 chat_log_id
    private String qnaId;        // FastAPI의 qna_id
    private String question;     // FastAPI의 question
    private String answer;       // FastAPI의 answer
    private String regDate;      // FastAPI의 reg_date (이미 문자열로 변환됨)
    private String uptDate;      // FastAPI의 upt_date (이미 문자열로 변환됨)
}

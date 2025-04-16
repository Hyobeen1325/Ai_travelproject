package com.example.demo.dto;

import java.util.List;

import lombok.Data;

@Data
public class JHResponseDto {
    private String response;
    private String upt_date;
    private String title;
    private String question;
    private String answer;
    private List<ChatLogItemDto> chatLogs; // FastAPI의 chat_logs (해당 이메일의 모든 채팅 로그 리스트)
    private List<QnaItemDto> qnaData;      // FastAPI의 qna_data (현재 로그와 관련된 모든 QNA 리스트)
}

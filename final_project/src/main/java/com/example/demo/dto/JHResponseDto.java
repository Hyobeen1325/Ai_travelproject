package com.example.demo.dto;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.Data;

@Data
public class JHResponseDto {
    private String response;
    @JsonProperty("titles")
    private List<String> titles;

    @JsonProperty("upt_dates")
    private List<Date> uptDates;

    @JsonProperty("chat_logs")
    private List<ChatLogItemDto> chatLogs;

    @JsonProperty("qna_data")
    private List<QnaItemDto> qnaData;

    @JsonProperty("questions")
    private List<String> questions;

    @JsonProperty("answers")
    private List<String> answers;
 // commit추가
}

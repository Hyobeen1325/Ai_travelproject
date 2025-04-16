package com.example.demo.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWThemeResponse {
	
	// 선택값
	private int choose_id;
	private String high_loc;
	private String low_loc;
	private String theme1;
	private String theme2;
	private String theme3;
	private String theme4;
	private int days;
	
	@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime regdate;
	@JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime uptdate;
	
    private String regdateS;
    private String uptdateS;
	

}

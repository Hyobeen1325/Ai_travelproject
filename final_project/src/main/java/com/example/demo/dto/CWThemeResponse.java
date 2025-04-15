package com.example.demo.dto;

import java.time.LocalDateTime;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWThemeResponse {
	
	// 선택값
	private int chooge_val_id;
	private String high_loc;
	private String low_loc;
	private List<String> theme1;
	private List<String> theme2;
	private List<String> theme3;
	private List<String> theme4;
	private int days;
    private LocalDateTime regdate;
    private LocalDateTime uptdate;
	

}

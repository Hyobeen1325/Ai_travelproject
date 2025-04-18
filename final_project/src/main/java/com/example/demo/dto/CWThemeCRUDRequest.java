package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWThemeCRUDRequest {
	
	// 선택값
	private String high_loc;
	private String low_loc;
	private String theme1;
	private String theme2;
	private String theme3;
	private String theme4;
	private int days;
	

}

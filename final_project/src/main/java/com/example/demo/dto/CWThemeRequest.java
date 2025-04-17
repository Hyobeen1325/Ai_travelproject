package com.example.demo.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWThemeRequest {
	
	// 선택값
	private String high_loc;
	private String low_loc;
	private List<String> theme;
	private int days;
	

}

package com.example.demo.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWThemeRequest {
	
	// 선택값 코드
	private String high_loc;
	private String high_loc2;
	private String low_loc;
	private List<String> theme;
	private int days;

	// 선택값 문자
	private String high_locS;
	private String low_locS;
	private List<String> themeS;

}

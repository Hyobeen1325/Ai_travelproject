package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class JHRequestDto2 {
    private String message;
    private String email;
    private String high_loc2;
	private String low_loc;
	private String theme1;
	private String theme2;
	private String theme3;
	private String theme4;
	private int days;
	// commit추가
}

package com.example.demo.dto;

import lombok.Data;

@Data
public class SignupDTO {
	private String email;
	private String name;
	private String nickname;
	private String pwd;
	private String phon_num; 
}

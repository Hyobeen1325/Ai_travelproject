package com.example.demo.dto;

import lombok.Data;

@Data // UpdatePwd
public class UpdatePwdDTO{
	private String new_pwd; // 새 비밀번호
	private String pwd; // 비밀번호 
}
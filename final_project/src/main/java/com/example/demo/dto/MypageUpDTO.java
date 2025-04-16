package com.example.demo.dto;

import lombok.Data;

@Data // UpdateModel
public class MypageUpDTO{ // 내정보 수정 
	private String email; // 이메일(아이디) 
	private String nickname; // 닉네임 
	private String phon_num; // 전화번호

}
package com.example.demo.dto;

import lombok.Data;

@Data
public class LoginDTO { // 로그인 유효성 검사 
    private String email; //아이디 
    private String pwd; // 비밀번호 
}
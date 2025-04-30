package com.example.demo.dto;

import lombok.Data;

@Data // AdminUpdate
public class AdminUpDTO { // 회원정보 수정
    private String email; //아이디 
    private String name; // 이름 
    private String nickname; // 닉네임 
    private String phon_num; // 전화번호
    
}
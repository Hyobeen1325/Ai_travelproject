package com.example.demo.dto;

import lombok.Data;
import java.time.LocalDateTime; // datetime

@Data // MemberBase
public class MemberDTO{ // member 테이블의 유저데이터 모델  
	private String email; // 이메일(아이디) 
    private String name; // 이름 
    private String nickname; //닉네임 
    private String pwd; // 비밀번호 
    private String phon_num; // 전화번호 
    private LocalDateTime reg_date; //생성일 
    private LocalDateTime upt_date; // 수정일
    private boolean admin; // 관리자 계정 설정
}
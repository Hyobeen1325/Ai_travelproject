package com.example.demo.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;

@Service 
public class SYService { 
	 private static final String FASTAPI_URL = "http://localhost:8000/login/member"; // FastAPI URL 
	 
	    public MemberDTO login(LoginDTO loginRequest) { //로그인 처리 모델
	        RestTemplate restTemplate = new RestTemplate(); // REST API와 통신

	        try {
	            // HTTP 요청 헤더 설정
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_JSON); // json 형식으로 반환

	            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
	            HttpEntity<LoginDTO> requestEntity = new HttpEntity<>(loginRequest, headers); 

	            // FastAPI로 POST 요청 전송
	            ResponseEntity<MemberDTO> response = restTemplate.postForEntity(FASTAPI_URL, requestEntity, MemberDTO.class);
	            return response.getBody();

	        } catch (Exception e) { // 예외 처리
	            System.err.println("FastAPI 로그인 요청 중 오류 발생: " + e.getMessage());
	            return null;
	        }
	    }
}
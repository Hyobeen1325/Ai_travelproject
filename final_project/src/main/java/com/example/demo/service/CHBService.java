package com.example.demo.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.SignupDTO;


@Service 
public class CHBService { // FastAPI URL 
	 private static final String Register_URL = "http://localhost:8000/auth/register";
	 
	// REST API(FastAPI)와 통신
		 private final RestTemplate restTemplate = new RestTemplate(); 
		 
		 	
		 	// 회원 가입 
		    /*public String register(SignupDTO registerRequest) { //로그인 처리 모델

		        try {
		            // HTTP 요청 헤더 설정
		            HttpHeaders headers = new HttpHeaders();
		            headers.setContentType(MediaType.APPLICATION_JSON); // json 형식으로 반환

		            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
		            HttpEntity<SignupDTO> requestEntity = new HttpEntity<>(registerRequest, headers); 

		            // FastAPI로 POST 요청 전송
		            ResponseEntity<SignupDTO> response = restTemplate.postForEntity(Register_URL, requestEntity, SignupDTO.class);
		            return response.getBody();

		        } catch (Exception e) { // 예외 처리
		            System.err.println("FastAPI 회원가입 요청 중 오류 발생: " + e.getMessage());
		            return null; // 무효화
		     }
		 
		 
		}*/
	    	
		 public String register(SignupDTO registerRequest) {
		    		restTemplate.postForObject(Register_URL , registerRequest, MemberDTO.class);
		    		return "등록성공";
		    }
	    
}
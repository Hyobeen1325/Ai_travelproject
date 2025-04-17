package com.example.demo.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;

@Service 
public class SYService { // FastAPI URL 
	 private static final String Login_URL = "http://localhost:8000/login/member"; 
	 private static final String Logout_URL = "http://localhost:8000/login/logout"; 
	 private static final String Mypaga_URL = "http://localhost:8000/login/mypage/{email}";
	 
	 // REST API(FastAPI)와 통신
	 private final RestTemplate restTemplate = new RestTemplate(); 
	 
	 	
	 	// 로그인 
	    public MemberDTO login(LoginDTO loginRequest) { //로그인 처리 모델

	        try {
	            // HTTP 요청 헤더 설정
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_JSON); // json 형식으로 반환

	            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
	            HttpEntity<LoginDTO> requestEntity = new HttpEntity<>(loginRequest, headers); 

	            // FastAPI로 POST 요청 전송
	            ResponseEntity<MemberDTO> response = restTemplate.postForEntity(Login_URL, requestEntity, MemberDTO.class);
	            return response.getBody();

	        } catch (Exception e) { // 예외 처리
	            System.err.println("FastAPI 로그인 요청 중 오류 발생: " + e.getMessage());
	            return null; // 무효화
	     }
	}
	    	
	   // 로그아웃 
	    public String logout() {
	    	  
	    	  try {
	    		 // FastAPI로 로그아웃 요청 전송
	    		 ResponseEntity<String> response = restTemplate.postForEntity(Logout_URL, null, String.class);
	    		 return response.getBody(); // 로그아웃 성공 메시지 반환
	    	
	    	  } catch (Exception e) { // 예외 처리
	    		 System.err.println("FastAPI 로그아웃 요청 중 오류 발생: " + e.getMessage());
	    	  	}return "로그아웃 실패!";  // 로그아웃 실패 
	    	  
	    }

	    
	   // 마이페이지 
	   // 내정보 조회 
	   public MemberDTO mypage(String email) { // 내정보 조회 모델
		   
		   try {
	            // FastAPI로 Get 요청 전송
	            ResponseEntity<MemberDTO> response = restTemplate.getForEntity(Mypaga_URL, MemberDTO.class, email);
	            return response.getBody();
	           
		   } catch (Exception e) { // 예외 처리
	            System.err.println("FastAPI 마이페이지 조 중 오류 발생: " + e.getMessage());
	            return null; // 무효화   
		   
		   }
	   	}
	   
	  
	   // 내정보 수정
	    public MemberDTO updateMypage(String email, MypageUpDTO updateRequest) {
	        try {
	            // HTTP 요청 헤더 설정
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_JSON); // JSON 형식으로 반환

	            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
	            HttpEntity<MypageUpDTO> requestEntity = new HttpEntity<>(updateRequest, headers); 

	            // FastAPI로 PUT 요청 전송
	            ResponseEntity<MemberDTO> response = restTemplate.exchange(Mypaga_URL, HttpMethod.PUT, requestEntity, MemberDTO.class, email);

	            // 수정된 데이터를 다시 조회
	            return response.getBody(); // 수정 후 다시 조회하여 반환
	            
	        } catch (Exception e) { // 예외 처리 
	            System.err.println("FastAPI 마이페이지 수정 중 오류 발생: " + e.getMessage());
	            return null; // 무효화 
	        }
	    }
	    
	    
	    
}
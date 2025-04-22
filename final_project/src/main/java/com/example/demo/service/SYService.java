package com.example.demo.service;

import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.dto.UpdatePwdDTO;
import com.example.demo.dto.FindIDDTO; 

@Service
public class SYService { // 유저 관리 서비스
    // FastAPI URL
    private static final String Login_URL = "http://localhost:8000/login/member";
    private static final String Logout_URL = "http://localhost:8000/login/logout";
    private static final String Mypaga_URL = "http://localhost:8000/login/mypage/{email}";
    private static final String NewPwd_URL = "http://localhost:8000/login/mypage/{email}/pwd";
    private static final String FindID_URL =  "http://localhost:8000/login/findid";
    
    
    // REST API(FastAPI)와 통신
    private final RestTemplate restTemplate = new RestTemplate(); 
    	// final : 상수(할당값 고정) 지정 키워드
    
    

    // 로그인
    public MemberDTO login(LoginDTO loginRequest) { 
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
            System.err.println("FastAPI 로그인 요청 중 오류 발생: " + e.getMessage()); // 에러 메세지
            return null; // 무효화
        }
    }

    // 로그아웃
    public String logout() {
        try {
            // FastAPI로 로그아웃 POST 요청 전송 
            ResponseEntity<String> response = restTemplate.postForEntity(Logout_URL, null, String.class);
            return response.getBody(); // 로그아웃 성공 메시지 반환
       
        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 로그아웃 요청 중 오류 발생: " + e.getMessage());
        }
        return "로그아웃 실패!";  // 로그아웃 실패
    }


    // 아이디 찾기
    public String findID(FindIDDTO findIDRequest) {
    	try {
    		// HTTP 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON); // json 형식으로 반환
            
            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
            HttpEntity<FindIDDTO> requestEntity = new HttpEntity<>(findIDRequest, headers);
            
            // FastAPI로 아이디 찾기 POST 요청 전송 
            ResponseEntity<Map> response = restTemplate.postForEntity(FindID_URL, requestEntity, Map.class);
            
            // HTTP 상태 코드 및 응답 본문 확인 
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null && response.getBody().containsKey("email")) {
                return (String) response.getBody().get("email"); 

            
            } else { 
                System.err.println("FastAPI 아이디 찾기 실패: " + response.getStatusCode());
                return null; // 무효화 
            }

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 아이디 찾기 요청 중 오류 발생: " + e.getMessage());
            return null; // 무효
        }
    }
  
    // 비밀번호 찾기 
    
    
    // 마이페이지
    // 내정보 조회
    public MemberDTO mypage(String email) { 
        try {
            // FastAPI로 GET 요청 전송
            ResponseEntity<MemberDTO> response = restTemplate.getForEntity(Mypaga_URL, MemberDTO.class, email);
            return response.getBody();
            
        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 마이페이지 조회 중 오류 발생: " + e.getMessage()); // 에러 메세지 
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

        } catch (HttpClientErrorException e) {
            // 이메일 중복 확인 
            if (e.getResponseBodyAs(String.class).contains("이미 사용 중인 이메일")) {
                System.out.println("이메일 중복확인 중 오류 발생");
                return null; // 무효화
            }
            System.err.println("FastAPI 마이페이지 수정 중 HTTP 오류 발생: " + e.getMessage());
            return null; // 무효화
            
        } catch (Exception e) { // 기타 예외 처리
            System.err.println("FastAPI 마이페이지 수정 중 기타 오류 발생: " + e.getMessage());
            return null; // 무효화 
        }
    }

    // 비밀번호 변경
    public MemberDTO updatePwd(String email, UpdatePwdDTO updateRequest) {
        try {
            // HTTP 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON); // JSON 형식으로 반환

            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
            HttpEntity<UpdatePwdDTO> requestEntity = new HttpEntity<>(updateRequest, headers);

            // FastAPI로 PUT 요청 전송
            ResponseEntity<MemberDTO> response = restTemplate.exchange(NewPwd_URL, HttpMethod.PUT, requestEntity, MemberDTO.class, email);

            // 수정된 데이터를 다시 조회
            return response.getBody(); // 수정 후 다시 조회하여 반환

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 비밀번호 변경 중 오류 발생: " + e.getMessage());
            return null; // 무효화
        }
    }
}
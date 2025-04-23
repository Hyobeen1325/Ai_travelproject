package com.example.demo.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.example.demo.dto.FindPwdDTO; 

@Service
public class SYService { // 유저 관리 서비스
    // FastAPI URL
    private static final String Login_URL = "http://localhost:8000/login/member";
    private static final String Logout_URL = "http://localhost:8000/login/logout";
    private static final String FindID_URL = "http://localhost:8000/login/findid";
    private static final String FindPwd_URL = "http://localhost:8000/login/findpwd";
    private static final String Mypaga_URL = "http://localhost:8000/login/mypage/{email}";
    private static final String NewPwd_URL = "http://localhost:8000/login/mypage/{email}/pwd";

    // REST API(FastAPI)와 통신
    private final RestTemplate restTemplate = new RestTemplate(); 
    	// final : 상수(할당값 고정) 지정 키워드
    
    // Email Service
    @Autowired
    private EmailService service; // 임시 비밀번호 발송에 사용
   

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
            
            // HTTP 상태 코드 및 응답 본문(body) 확인 
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null && response.getBody().containsKey("email")) {
                return (String) response.getBody().get("email"); 

            
            } else { 
                System.err.println("FastAPI 아이디 찾기 실패: " + response.getStatusCode());
                return null; // 무효화 
            }

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 아이디 찾기 요청 중 오류 발생: " + e.getMessage());
            return null; // 무효화 
        }
    }
  
    // 비밀번호 찾기 
    public String findPwd(FindPwdDTO findPwdRequest) {
    	try {
    		// HTTP 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON); // json 형식으로 반환
            
            // 요청 데이터 (email만 포함)
            Map<String, String> requestBody = new HashMap<>();
            requestBody.put("email", findPwdRequest.getEmail());

            // 요청 데이터(body)와 헤더를 포함한 엔티티 생성
            HttpEntity<Map<String, String>> requestEntity = new HttpEntity<>(requestBody, headers);
            
            // FastAPI로 비밀번호 찾기 POST 요청 전송 
            ResponseEntity<Map> response = restTemplate.postForEntity(FindPwd_URL, requestEntity, Map.class);
            
            // HTTP 상태 코드 및 응답 본문(body) 확인 
            // 발송 성공
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null && response.getBody().containsKey("temp_pwd")) {
                String temp_pwd = (String) response.getBody().get("temp_pwd");
                String email = findPwdRequest.getEmail();
                service.sendEmail(email, "[소담여행] - 임시 비밀번호 발송 안내", 
                		"소담여행을 찾아주셔서 감사합니다.\r\n"
                		+"회원님의 임시 비밀번호는 " + temp_pwd + " 입니다.\r\n"
                		+"빠른 시일 내에 소담여행 사이트를 방문하여, 비밀번호를 변경하시는 것을 권장드립니다.\r\n"
                		+"감사합니다.\r\n"
                		+"-소담여행 드림-\r\n"
                		+"\r\n"
                		+"\r\n"
                		+"소담여행 사이트 방문하기🌌 : [http://sodam.com]\r\n");
                return  "임시 비밀번호 발송 완료"; 
            
            // 이메일 유효성 검사
            } else if (response.getStatusCode() == org.springframework.http.HttpStatus.NOT_FOUND) {
                return "존재하지 않는 이메일입니다."; // 실제 사용 중인 이메일(구글, 네이버 등) 유효성 검사
                
            } else { // 발송 실패 
                System.err.println("FastAPI 비밀번호 찾기 실패: " + response.getStatusCode());
                return "임시 비밀번호 발송 실패";
            }

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 비밀번호 찾기 요청 중 오류 발생: " + e.getMessage());
            return "임시 비밀번호 발송 요청 중 오류가 발생했습니다";
        }
    	
    }
    
    
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
package com.example.demo.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.dto.UpdatePwdDTO;
import com.example.demo.dto.AdminUpDTO;
import com.example.demo.dto.FindIDDTO; 
import com.example.demo.dto.FindPwdDTO; 

@Service
public class SYService { // 유저 관리 서비스
    // FastAPI URL
    private static final String Login_URL = "http://localhost:8000/login/member";
    private static final String Admin_URL = "http://localhost:8000/login/admin";
    private static final String Admin_Name_URL = "http://localhost:8000/login/admin/{member_name}";
    private static final String Admin_Email_URL = "http://localhost:8000/login/admin/{member_email}";
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
                		+"소담여행 사이트 방문하기🌌 : http://sodam.com\r\n");
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
    
    // 관리자(admin) 페이지 
    // 회원정보 조회
    public List<MemberDTO> adminpage() {
        try {
            // FastAPI로 GET 요청 전송
            ResponseEntity<List<MemberDTO>> response = restTemplate.exchange(
                    Admin_URL, HttpMethod.GET, null,
                    new ParameterizedTypeReference<List<MemberDTO>>(){}
            );
            return response.getBody();

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 관리자 페이지 조회 중 오류 발생: "+e.getMessage());
            return null; // 무효화
        }
    }
    
    // 일부 회원정보 조회 (이름) : 검색용
    public List<MemberDTO> adminMemberNeme(String memberName){
        try {
            // FastAPI로 GET 요청 전송
            // List : 한 명 이상 조회하는 경우
            ResponseEntity<List<MemberDTO>> response = restTemplate.exchange(
                    // restTemplate : 제네릭 타입
                    // 제너릭 타입 : 프로그래밍 언어에서 타입을 파라미터처럼 사용함.
                    Admin_Name_URL, HttpMethod.GET, null,
                    new ParameterizedTypeReference<List<MemberDTO>>(){},
                    // 제네릭 타입(List) 유지로, 응답 모델 타입 명시함.
                    memberName // {member_name}
                    // URI(Admin_Name_URL) 템플릿 변수에 값을 할당함.
            );
            return response.getBody();
    		
        } catch (HttpClientErrorException e) { // 클라이언트 측 & Http 오류 처리
            HttpStatusCode statusCode = e.getStatusCode();
            if (statusCode == HttpStatus.NOT_FOUND) { // 404 에러 : 리소스를 찾을 수 없음
                System.err.println("FastAPI 관리자 페이지 회원정보 이름으로 조회 실패로, 존재하지 않는 회원 : "
                        + "(상태 코드 :" + statusCode.value() + ")"); // 상태 코드 확인
                return null; // 무효화
            } else { // 404 이외, 서버 또는 통신 관련 오류 예외 처리
                System.err.print("FastAPI 관리자 페이지 회원정보 이름으로 조회 중 Http 오류 발생 : "
                        + "(상태 코드: " + statusCode.value()
                        + ", 메시지: " + e.getMessage() + ")");
                return null; // 무효화
            }

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 관리자 페이지 회원정보 이름으로 조회 중 오류 발생: "+e.getMessage());
            return null; // 무효화
        }
    }
    
 // 회원정보 수정
    public MemberDTO updateAdminMember(String memberEmail, AdminUpDTO updateRequest) {
        try {
            // HTTP 요청 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON); // JSON 형식으로 반환

            // 요청 데이터(body)와 헤더(header)를 포함한 엔티티 생성
            HttpEntity<AdminUpDTO> requestEntity = new HttpEntity<>(updateRequest, headers);

            // FastAPI로 PUT 요청 전송
            ResponseEntity<MemberDTO> response = restTemplate.exchange(
                    Admin_Email_URL, HttpMethod.PUT, requestEntity,
                    MemberDTO.class, memberEmail // URL 경로 변수에 값 할당
            );
            return response.getBody();

        } catch (HttpClientErrorException e) {
            HttpStatusCode statusCode = e.getStatusCode();
            if (statusCode == HttpStatus.NOT_FOUND) { // 404 에러 : 리소스를 찾을 수 없음
                System.err.println("FastAPI 관리자 페이지 회원정보 수정 실패: 존재하지 않는 회원 (상태 코드: " + statusCode.value() + ")");
                return null; // 무효화
            } else { // 404 이외, 서버 또는 통신 관련 에러 예외 처리
                System.err.println("FastAPI 관리자 페이지 회원정보 수정 중 HTTP 오류 발생: (상태 코드: " + statusCode.value() + ", 메시지: " + e.getMessage() + ")");
                return null; // 무효화
            }

        } catch (Exception e) { // 예외 처리
            System.err.println("FastAPI 관리자 페이지 회원정보 수정 중 오류 발생: " + e.getMessage());
            return null; // 무효화
        }
    }
    
    // 회원 탈퇴 (삭제)
    /*
    public boolean deleteAdminMember(String memberEmail) {
        try {
            // <Map> : {"msg":"메세지 내용"}
            // FastAPI에서 DELETE 요청
            ResponseEntity<Map> response = restTemplate.exchange(
                    Admin_Email_URL, HttpMethod.DELETE, null,
                    Map.class, memberEmail // URL 경로 변수에 값 할당
            );
            // http 응답 코드 범위로 탈퇴 여부 확인
            HttpStatusCode statusCode = response.getStatusCode();
            if (statusCode.is2xxSuccessful()) {
                return true;
            } else {
                // FastAPI에서 실패 시 특정 메시지를 반환하는 경우 확인
                if (response.getBody() != null && response.getBody().containsKey("msg")) {
                    System.err.println("FastAPI 회원 탈퇴 실패: " + response.getBody().get("msg"));
                } else {
                    System.err.println("FastAPI 회원 탈퇴 실패: 상태 코드 " + statusCode.value());
                }
                return false;
            }

        } catch (HttpClientErrorException e) {
            HttpStatusCode statusCode = e.getStatusCode();
            System.err.println("FastAPI 관리자 회원 탈퇴 오류 (상태 코드: " + statusCode.value() + ", 메시지: " + e.getResponseBodyAsString() + ")");
            return false;

        } catch (Exception e) {
            System.err.println("FastAPI 관리자 회원 탈퇴 중 오류 발생: " + e.getMessage());
            return false;
        }
    }
*/

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
package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.MypageUpDTO;
import com.example.demo.service.SYService;

@Controller
@RequestMapping("/login")  // 클래스 공통 경로
public class SYController { // 유저 관리 컨트롤러
    
	// Rest API
    @Value("${kakao.client_id}") 
    private String client_id;
    
    // Redirect URI
    @Value("${kakao.redirect_uri}")
    private String redirect_uri;
    
    // Member service
    @Autowired
    private SYService service;

    // 로그인 페이지 
    // http://localhost:8080/login
    @GetMapping("")
    public String loginpage(Model model) {
        // kakao 로그인 성공 시, URL 생성 후 login.jsp로 전달
        String location = "https://kauth.kakao.com/oauth/authorize?response_type=code"
                        + "&client_id=" + client_id // REST API 키
                        + "&redirect_uri=" + redirect_uri; // Redirect URI
        model.addAttribute("location", location); 

        return "login"; // /WEB-INF/jsp/login.jsp
    }
    
    // kakao 로그인 redirect 
    // http://localhost:8080/login/kakaologin?code=...
    @GetMapping("/kakaologin")
    public String kakaologin(@RequestParam("code") String code, Model model) {
        // TODO: 카카오 access_token 요청 및 사용자 정보 처리
        model.addAttribute("msg", "카카오 로그인 성공! 받은 code: " + code);
        // 메인 페이지로 이동 
        return "redirect:/project1"; //  /WEB-INF/jsp//project1.jsp
    }
    

    // 회원가입 페이지
    @GetMapping("/join")
    public String joinpage() {
        return "/Membership_managemen"; // /WEB-INF/jsp/Membership_managemen.jsp
    }
        
    // 로그인 유효성 검사 (아이디, 비밀번호) 
    @PostMapping("/member")
    public String login(LoginDTO loginRequest, Model model) {
    	 MemberDTO response = service.login(loginRequest); // db 일치 여부 확인
    	 
    	 // 로그인 성공 
    	 if (response != null) {
             model.addAttribute("msg", "로그인 성공!"); // 성공 메세지 
             model.addAttribute("member", response); 
             return "mypage"; // /WEB-INF/jsp/project1.jsp
             
         // 로그인 실패     
         } else {
             model.addAttribute("msg", "아이디 또는 비밀번호가 일치하지 않습니다.");
             return "login"; // /WEB-INF/jsp/login.jsp
         }
   
   }
    
    // 로그아웃 
    @PostMapping("/logout")
    public String logout(Model model) {
    	String response = service.logout();
    	model.addAttribute("msg", response);
    	return "redirect:/login";
    }
    
    
    // 마이 페이지 (내정보 관리)
    // http://localhost:8080/login/mypage
    
    // 내정보 조회 
    @GetMapping("/mypage/{email}")
    public String mypage(@PathVariable("email") String email, Model model) {
    	MemberDTO response = service.mypage(email); // db 일치 여부 확인
    	
    	// 내정보 조회 성공 
    	if (response != null) {
    		model.addAttribute("msg", "내정보 조회 성공!");
    		model.addAttribute("member", response);
    		return "mypage"; //  /WEB-INF/jsp/mypage.jsp
    	
    	// 내정보 조회 실패 
    	} else {
    		model.addAttribute("msg","내정보 조회 실패!");	
            return "redirect:/login"; // /WEB-INF/jsp/login.jsp
    		
    	}
    
    }
    
    // 내정보 수정
    @PostMapping("/mypage/{email}")
    public String updateMypage(@PathVariable("email") String email, 
            @ModelAttribute MypageUpDTO updateRequest, Model model) {
        
    	// 수정된 member db 저장 후 정보 가져오기
    	MemberDTO response = service.updateMypage(email, updateRequest);  

        if (response != null) { // 내정보 수정 성공 
            model.addAttribute("msg", "내정보 수정 성공!");
            model.addAttribute("member", response); // 수정된 회원 정보 전달
            return "mypage"; // /WEB-INF/jsp/mypage.jsp
            
        } else { // 내정보 수정 실패 
            model.addAttribute("msg", "내정보 수정 실패!");
            return "login"; 
       }
   }
    
    
    
    
}
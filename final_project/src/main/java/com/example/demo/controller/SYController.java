package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.LoginDTO;
import com.example.demo.dto.MemberDTO;
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
    public String join() {
        return "/Membership_managemen"; // /WEB-INF/jsp/Membership_managemen.jsp
    }
    
    
    @Autowired
    private SYService service; // member service
    
    // 로그인 유효성 검사 (아이디, 비밀번호) 
    @PostMapping("/member")
    public String login(LoginDTO loginRequest, Model model) {
    	 MemberDTO response = service.login(loginRequest); // db 일치 여부 
    	 
    	 // 로그인 성공 
    	 if (response != null) {
             model.addAttribute("msg", "로그인 성공!"); // 성공 메세지 
             model.addAttribute("member", response); 
             return "redirect:/project1"; // /WEB-INF/jsp/project1.jsp
             
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
    @GetMapping("/mypage")
    public String mypage() {
        return "mypage"; // /WEB-INF/jsp/mypage.jsp
    }
    

    
}

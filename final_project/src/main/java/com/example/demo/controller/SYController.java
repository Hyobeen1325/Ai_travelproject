package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
    public String login(Model model) {
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
        return "redirect:/page0"; //  /WEB-INF/jsp/page0.jsp
    }
    
    // 마이 페이지 (내정보 관리)
    // http://localhost:8080/login/mypage
    @GetMapping("/mypage")
    public String mypage() {
        return "mypage"; // /WEB-INF/jsp/mypage.jsp
    }
}

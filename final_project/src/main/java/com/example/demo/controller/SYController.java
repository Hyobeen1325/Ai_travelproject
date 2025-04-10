package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@RequestMapping("/login")  // 클래스 공통 경로
public class SYController { //유저 관리 컨트롤러
	
	// 로그인 페이지
	// http://localhost:8080/login
	@GetMapping("")
	public String login() {
		return "login";
	}
	
	//마이 페이지 (내정보 관리)
	// http://localhost:8080/login/mypage
	@GetMapping("/mypage")
	public String mypage() {
		return "mypage";
	}

}

package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HB2Controller {
	
	@RequestMapping("/test")
	public String test() {
		return "test";
	}
	
	@RequestMapping("/kakaoAPI")
	public String kakao() {
		return "kakaoAPI";
	}
	
	@RequestMapping("/transit")
	// http://localhost:8080/transit
	public String transit() {
		return "transit";
	}
}

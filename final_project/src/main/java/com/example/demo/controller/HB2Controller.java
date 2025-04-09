package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HB2Controller {
	
	@GetMapping("/test")
	public String test() {
		return "test";
	}
	
}

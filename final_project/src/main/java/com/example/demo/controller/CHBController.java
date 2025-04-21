package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CHBController {

	@GetMapping("/project1")
	public String getproject1() {
		return "project1";
	}
	@GetMapping("/page0")
	public String getpage0() {
		return "page0";
	}
	@GetMapping("/page1")
	public String getpage1() {
		return "page1";
	}
	@GetMapping("/page2")
	public String getpage2() {
		return "page2";
	}
	@GetMapping("/page3")
	public String getpage3() {
		return "page3";
	}
}

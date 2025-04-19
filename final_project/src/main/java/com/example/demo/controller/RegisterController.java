package com.example.demo.controller;

import com.example.demo.dto.SignupDTO;
import com.example.demo.service.CHBService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody; // 추가
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/register")
public class RegisterController {

    @Autowired
    private CHBService service;

    @GetMapping("")
    public String getRegisterForm() {
        return "register";
    }

    @PostMapping("/signupProcess")
    public String signupProcess(@RequestBody SignupDTO signupDTO) { // @RequestBody로 변경
        SignupDTO registeredUser = service.register(signupDTO);

        if (registeredUser != null) {
            // 회원 가입 성공 처리 (예: 성공 페이지로 리다이렉트)
            return "redirect:/login"; // 로그인 페이지로 리다이렉트
        } else {
            // 회원 가입 실패 처리 (예: 실패 메시지를 보여주는 페이지로 이동)
            return "register"; // 회원 가입 페이지 다시 보여주기
        }
    }
}
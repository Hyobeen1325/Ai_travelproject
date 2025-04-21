package com.example.demo.controller;

import com.example.demo.dto.SignupDTO;
import com.example.demo.service.CHBService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody; // 추가
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

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
    @ResponseBody //json 메세지를 가져온다
    public ResponseEntity<?> signupProcess(@RequestBody SignupDTO signupDTO) { // @RequestBody로 변경
        String message = service.register(signupDTO);

            return ResponseEntity.ok(message); // 회원 가입 페이지 다시 보여주기
        
    }
}
package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.service.JHService;

@Controller
public class JHController {

    @Autowired
    private JHService jhService;

    /**
     * 질문 입력 폼 페이지 (page04)
     */
    @GetMapping("/ask")
    public String showQuestionForm() {
        // "ask-form" 대신 "page04"를 반환하도록 수정
        return "page04";
    }

    /**
     * 질문 처리 및 결과 표시 페이지 (page05) - POST 방식
     * page04에서 form submit 시 호출됨
     */
    @PostMapping("/ask")
    public String processQuestionAndShowResult(@RequestParam("message") String message, Model model) {
        // DTO 생성
        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(message);
        
        // FastAPI 서비스 호출
        String response = jhService.getJHResponse(requestDto);
        
        // 모델에 데이터 추가
        model.addAttribute("query", message); // 사용자가 입력한 질문
        model.addAttribute("aiResponse", response); // FastAPI로부터 받은 응답
        
        // 결과 페이지인 "page05"를 반환
        return "page05";
    }
    
    /**
     * 질문 처리 및 결과 표시 페이지 (page05) - GET 방식
     * page05 자체의 검색 폼에서 사용될 수 있음
     */
    @GetMapping("/chat.do")
    public String handleChatRequest(@RequestParam(value = "query", required = false) String query, Model model) {
        // 질문이 없는 경우, 기본 page05 표시 (또는 page04로 리다이렉트도 가능)
        if (query == null || query.trim().isEmpty()) {
             model.addAttribute("aiResponse", "질문을 입력해주세요."); // 기본 메시지 설정
            return "page05"; 
        }
        
        // DTO 생성
        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(query);
        
        // FastAPI 서비스 호출
        String response = jhService.getJHResponse(requestDto);
        
        // 모델에 데이터 추가
        model.addAttribute("query", query);
        model.addAttribute("aiResponse", response); 
        
        // 결과 페이지인 "page05"를 반환
        return "page05";
    }
}
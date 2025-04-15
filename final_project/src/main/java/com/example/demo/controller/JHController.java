package com.example.demo.controller;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHResponseDto;
import com.example.demo.service.JHService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class JHController {

    @Autowired
    private JHService jhService;

    // 질문 입력 폼 페이지 (page04)
    @GetMapping("/ask")
    public String showQuestionForm() {
        return "page04";
    }

    // POST 방식 질문 처리 (page04 -> page05)
    @PostMapping("/ask")
    public String processQuestionAndShowResult(@RequestParam("message") String message, Model model) {
        return handleQuery(message, model);
    }

    // GET 방식 질문 처리 (page05 내 검색창 -> page05)
    @GetMapping("/chat.do")
    public String handleChatRequest(@RequestParam(value = "query", required = false) String query, Model model) {
        if (query == null || query.trim().isEmpty()) {
            model.addAttribute("aiResponse", "질문을 입력해주세요.");
            return "page05";
        }
        return handleQuery(query, model);
    }

    // 공통 로직 분리
    private String handleQuery(String query, Model model) {
        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(query);

        JHResponseDto responseDto = jhService.getJHResponseWithLocation(requestDto);

        model.addAttribute("query", query);
        model.addAttribute("aiResponse", responseDto.getResponse());

        if (responseDto.getLocation() != null) {
            model.addAttribute("location", responseDto.getLocation());
        }

        return "page05";
    }
}
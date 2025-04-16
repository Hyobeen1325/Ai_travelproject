package com.example.demo.controller;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHResponseDto;
import com.example.demo.service.JHService;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class JHController {

    @Autowired
    private JHService jhService;
    
    @GetMapping("/dummylogin")
    public String showLoginPage() {
        return "dummylogin"; // dummylogin.jsp
    }

    @PostMapping("/dummylogin")
    public String processLogin(@RequestParam("email") String email, HttpSession session) {
        // 이메일 세션에 저장
        session.setAttribute("email", email);

        // 로그인 후 질문 입력 페이지로 리다이렉트
        return "redirect:/ask";
    }
    /** 
     * page04 - 질문 입력 폼 
     * 이메일 세션 없으면 접근 불가
     */
    @GetMapping("/ask")
    public String showQuestionForm(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");

        if (email == null || email.trim().isEmpty()) {
            return "redirect:/dummylogin";
        }

        model.addAttribute("username", email);
        return "page04";
    }

    /**
     * page05 - 질문 제출 처리 (POST)
     */
    @PostMapping("/ask")
    public String processQuestionAndShowResult(@RequestParam("message") String message,
                                               HttpSession session,
                                               Model model) {
        String email = (String) session.getAttribute("email");

        if (email == null || email.trim().isEmpty()) {
            return "redirect:/dummylogin";
        }

        // 요청 DTO 생성
        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(message);
        requestDto.setEmail(email); // 이메일도 FastAPI로 전송

        // 복합 응답 받기
        JHResponseDto responseDto = jhService.getJHResponse(requestDto);

        // 모델에 모든 정보 전달
        model.addAttribute("username", email);
        model.addAttribute("query", message);
        model.addAttribute("aiResponse", responseDto.getResponse());
        model.addAttribute("chatLogs", responseDto.getChatLogs());
        model.addAttribute("qnaData", responseDto.getQnaData());

        return "page05";
    }

    /**
     * page05 - GET 요청 (검색용 or 직접 접근)
     * 세션이 없어도 접근 가능
     */
    @GetMapping("/chat.do")
    public String handleChatRequest(@RequestParam(value = "query", required = false) String query,
                                    HttpSession session,
                                    Model model) {
        String email = (String) session.getAttribute("email");
        model.addAttribute("username", email); // null이어도 JSP에 전달

        if (query == null || query.trim().isEmpty()) {
            model.addAttribute("aiResponse", "질문을 입력해주세요.");
            return "page05";
        }

        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(query);
        requestDto.setEmail(email); // 있을 경우에만 사용 가능

        JHResponseDto responseDto = jhService.getJHResponse(requestDto);

        model.addAttribute("query", query);
        model.addAttribute("aiResponse", responseDto.getResponse());
        model.addAttribute("chatLogs", responseDto.getChatLogs());
        model.addAttribute("qnaData", responseDto.getQnaData());

        return "page05";
    }
}

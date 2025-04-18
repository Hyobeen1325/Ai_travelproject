package com.example.demo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHResponseDto;
import com.example.demo.dto.QnaItemDto;
import com.example.demo.service.JHService;

import jakarta.servlet.http.HttpSession;

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
        session.setAttribute("email", email);
        return "redirect:/ask";
    }

    @GetMapping("/ask")
    public String showQuestionForm(HttpSession session, Model model) {
        String email = (String) session.getAttribute("email");

        if (email == null || email.trim().isEmpty()) {
            return "redirect:/dummylogin";
        }

        model.addAttribute("username", email);
        return "page04";
    }

    @PostMapping("/ask")
    public String processQuestionAndShowResult(@RequestParam("message") String message,
                                               HttpSession session,
                                               Model model) {
        String email = (String) session.getAttribute("email");

        if (email == null || email.trim().isEmpty()) {
            return "redirect:/dummylogin";
        }

        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(message);
        requestDto.setEmail(email);

        try {
            var resultMap = jhService.getJHResponse(requestDto);

            model.addAttribute("username", email);
            model.addAttribute("query", message);
            model.addAttribute("aiResponse", resultMap.get("response"));

            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatLogs");
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaData");
            model.addAttribute("chatList", chatList);
            model.addAttribute("qnaList", qnaList);
            
        } catch (Exception e) {
            model.addAttribute("aiResponse", "응답 처리 중 오류 발생");
        }

        return "page05";
    }

    @GetMapping("/chat.do")
    public String handleChatRequest(@RequestParam(value = "query", required = false) String query,
                                    HttpSession session,
                                    Model model) {
        String email = (String) session.getAttribute("email");
        model.addAttribute("username", email);

        if (query == null || query.trim().isEmpty()) {
            model.addAttribute("aiResponse", "질문을 입력해주세요.");
            return "page05";
        }

        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(query);
        requestDto.setEmail(email);

        try {
            var resultMap = jhService.getJHResponse(requestDto);

            model.addAttribute("query", query);
            model.addAttribute("aiResponse", resultMap.get("response"));

            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatLogs");
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaData");
            model.addAttribute("chatList", chatList);
            model.addAttribute("qnaList", qnaList);
            
        } catch (Exception e) {
            model.addAttribute("aiResponse", "응답 처리 중 오류 발생");
        }

        return "page05";
    }
}

package com.example.demo.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.Item;
import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.MemberDTO;
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
        return "page05";
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
    
    MemberDTO member = (MemberDTO) session.getAttribute("SessionMember");
    String email = member.getEmail();
    	

        // ✅ 이전 aiResponse2 유지
        model.addAttribute("aiResponse2", session.getAttribute("aiResponse2"));
        model.addAttribute("areaListO",session.getAttribute("areaListO"));
        model.addAttribute("latitude", session.getAttribute("latitude"));
        model.addAttribute("longitude", session.getAttribute("longitude"));

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
            List<String> dateLabels = new ArrayList<>();
            LocalDate today = LocalDate.now();  // 오늘 날짜

            // chatList가 List<Item> 형태라고 가정
            for (ChatLogItemDto item : chatList) {
                // item에서 upt_date 가져오기 (Date 형태)
                Date upt_date = item.getUpt_date(); // 단일 Date

                if (upt_date == null) {
                    dateLabels.add("알 수 없음");
                    continue;
                }

                // Date를 LocalDate로 변환
                LocalDate date = upt_date.toInstant()
                                         .atZone(ZoneId.systemDefault())
                                         .toLocalDate();

                // 날짜 비교
                long daysBetween = ChronoUnit.DAYS.between(date, today);

                if (daysBetween == 0) {
                    dateLabels.add("오늘");
                } else if (daysBetween == 1) {
                    dateLabels.add("어제");
                } else if (daysBetween <= 7) {
                    dateLabels.add("최근 7일간");
                } else if (daysBetween <= 30) {
                    dateLabels.add("최근 1달");
                } else {
                    dateLabels.add("최근 1달 이후");
                }
            }
            model.addAttribute("dateLabels", dateLabels);
            
            
            
            

        } catch (Exception e) {
            model.addAttribute("aiResponse", "응답 처리 중 오류 발생");
        }

        return "page05";
    }
    

}

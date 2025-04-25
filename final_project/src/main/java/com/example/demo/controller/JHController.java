package com.example.demo.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.ChatLogItemDto;
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
        // commit추가
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
    @ResponseBody
    public Map<String, Object> handleChatRequest(@RequestParam(value = "query", required = false) String query,
                                                 HttpSession session) {
        // Session에서 사용자 정보를 가져오기
        MemberDTO member = (MemberDTO) session.getAttribute("SessionMember");
        String email = member.getEmail();

        // 응답 데이터 구성할 Map
        Map<String, Object> responseMap = new HashMap<>();

        // 입력 값이 없으면 기본 메시지 반환
        if (query == null || query.trim().isEmpty()) {
            responseMap.put("aiResponse", "질문을 입력해주세요.");
            return responseMap;
        }

        // JHRequestDto 객체 생성 후 입력 값 설정
        JHRequestDto requestDto = new JHRequestDto();
        requestDto.setMessage(query);
        requestDto.setEmail(email);

        try {
            // 챗봇 응답 데이터 받기
            var resultMap = jhService.getJHResponse(requestDto);

            // 응답 내용 저장
            responseMap.put("aiResponse", resultMap.get("response"));
            
            // 채팅 로그 데이터 (ChatLogItemDto 리스트)
            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatLogs");
            responseMap.put("chatList", chatList);

            // QnA 데이터 (QnaItemDto 리스트)
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaData");
            responseMap.put("qnaList", qnaList);

            // 날짜 라벨 처리
            List<String> dateLabels = new ArrayList<>();
            LocalDate today = LocalDate.now(); // 오늘 날짜

            // 날짜 라벨 생성
            for (ChatLogItemDto item : chatList) {
                Date upt_date = item.getUpt_date(); // 단일 Date
                if (upt_date == null) {
                    dateLabels.add("알 수 없음");
                    continue;
                }

                LocalDate date = upt_date.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

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
            responseMap.put("dateLabels", dateLabels);

        } catch (Exception e) {
            // 오류 처리
            responseMap.put("aiResponse", "응답 처리 중 오류 발생");
        }

        return responseMap; // JSON 형태로 반환
    }
    

}
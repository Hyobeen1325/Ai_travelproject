package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.JHRequestDto2;
import com.example.demo.dto.QnaItemDto;
import com.example.demo.service.JHService;

@Controller
public class JHController2 {

    @Autowired
    private JHService jhService;

    @GetMapping("/areaTest")
    public String handleAreaRequest(@RequestParam(value = "query", required = false) String query, Model model) {
        if (query == null || query.trim().isEmpty()) {
            model.addAttribute("aiResponse2", "질문을 입력해주세요.");
            return "page04";
        }

        JHRequestDto2 requestDto = new JHRequestDto2();
        requestDto.setMessage(query);

        try {
            var resultMap = jhService.getJHResponse2(requestDto);

            model.addAttribute("query2", query);
            model.addAttribute("aiResponse2", resultMap.get("response"));
            model.addAttribute("latitude", resultMap.get("latitude"));
            model.addAttribute("longitude", resultMap.get("longitude"));

            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatList");
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaList");
            model.addAttribute("chatList", chatList);
            model.addAttribute("qnaList", qnaList);

        } catch (Exception e) {
            model.addAttribute("aiResponse2", "응답 처리 중 오류 발생");
            model.addAttribute("latitude", null);
            model.addAttribute("longitude", null);
        }

        return "page04";
    }
}

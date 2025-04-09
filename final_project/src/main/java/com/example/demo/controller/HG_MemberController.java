package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
// http://localhost:8080/admin/member
@RequestMapping("/admin/member")
public class HG_MemberController {

    @GetMapping("")
    public String listMembers(
            @RequestParam(value = "searchKeyword", defaultValue = "") String searchKeyword,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "10") int size,
            Model model) {
        
        // 페이지네이션 계산
        int totalItems = 100; // 실제로는 DB에서 전체 회원 수 조회
        int totalPages = (int) Math.ceil((double) totalItems / size);
        int startIndex = (page - 1) * size;
        
        // 유효성 검사
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        // 모델에 속성 추가
        model.addAttribute("searchKeyword", searchKeyword);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalItems", totalItems);

        return "Membership_management";
    }
}
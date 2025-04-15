package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWThemeResponse;
import com.example.demo.service.CWThemeService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final에 자동으로 생성자 만드는 어노테이션
@Controller
@RequestMapping("/choose_val")
public class CW_CV_Controller {

    // 관광 API 값 받는 서비스단
    @Autowired
    private final CWThemeService themeService;
    
    // 기본 페이지
    @GetMapping
    public String choose_val_view() {
        return "cw-test/choose_val";
    }

    // 등록 페이지
    @PostMapping
    public String createStudent(
    		@RequestBody CWThemeRequest request,
    		Model model
    		) {
    	CWThemeResponse response = themeService.insertChooseVal(request);
    	model.addAttribute("response", response);
    	
        return "cw-test/choose_val";
    }

    // 전체조회 페이지
    @GetMapping("s")
    public String getAllStudents(Model model) {
    	List<CWThemeResponse> response = themeService.gatAllChooseVal();
    	model.addAttribute("response", response);
    	
        return "cw-test/choose_val";
    }

    // 단일조회 페이지
    @GetMapping("/{id}")
    public String getStudent(
    		@PathVariable int choose_id,
    		Model model) {
    	CWThemeResponse response = themeService.getChooseValById(choose_id);
    	model.addAttribute("response", response);
    	
        return "cw-test/choose_val";
    }

    // 수정페이지
    @PutMapping("/{id}")
    public String updateStudent(
    		@PathVariable int choose_id,
    		@RequestBody CWThemeRequest request,
    		Model model) {
    	CWThemeResponse response = themeService.updateChooseVal(choose_id, request);
    	model.addAttribute("response", response);
    	
        return "cw-test/choose_val";
    }

    //삭제 페이지
    @DeleteMapping("/{id}")
    public String deleteStudent(
    		@PathVariable int id,
    		Model model) {
    	String deleteMessage = themeService.deleteChooseVal(id);
    	model.addAttribute("deleteMessage", deleteMessage);
    	
        return "cw-test/choose_val";
    }
    
}

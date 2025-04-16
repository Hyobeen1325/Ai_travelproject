package com.example.demo.controller;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.CWThemeCRUDRequest;
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
    
    // 기본 등록 페이지
    @GetMapping
    public String choose_val_view() {
        return "cw-test/choose_val";
    }

    // 등록 페이지
    @PostMapping
    public String createStudent(
    		@RequestBody CWThemeCRUDRequest request,
    		Model model
    		) {
    	String message = themeService.insertChooseVal(request);
    	model.addAttribute("message", message);
    	
        return "cw-test/choose_val";
    }

    // 전체조회 페이지
    @GetMapping("/All")
    public String getAllStudents(Model model) {
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yy-MM-dd");
    	
    	List<CWThemeResponse> chooses = themeService.gatAllChooseVal();
    	
    	for(CWThemeResponse choose:chooses) {
        	String formattedRegdate = choose.getRegdate().format(formatter);
        	String formattedUptdate = choose.getUptdate().format(formatter);
        	choose.setRegdateS(formattedRegdate);
        	choose.setUptdateS(formattedUptdate);
    	}
    	
    	model.addAttribute("chooses", chooses);
    	
        return "cw-test/choose_vals";
    }

    // 단일조회 페이지
    @GetMapping("/One")
    public String getStudent(
    		@RequestParam("choose_id") int choose_id,
    		Model model) {
    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yy-MM-dd");
    	
    	CWThemeResponse choose = themeService.getChooseValById(choose_id);
    	
    	String formattedRegdate = choose.getRegdate().format(formatter);
    	String formattedUptdate = choose.getUptdate().format(formatter);
    	choose.setRegdateS(formattedRegdate);
    	choose.setUptdateS(formattedUptdate);
    	
    	model.addAttribute("choose", choose);
    	
        return "cw-test/choose_val";
    }

    // 수정페이지
    @PutMapping
    public String updateStudent(
    		@RequestParam("choose_id") int choose_id,
    		@RequestBody CWThemeCRUDRequest request) {
        return themeService.updateChooseVal(choose_id, request);
    }

    //삭제 페이지
    @DeleteMapping
    public String deleteStudent(
    		@RequestParam("choose_id") int choose_id) {
        return themeService.deleteChooseVal(choose_id);
    }
    
}

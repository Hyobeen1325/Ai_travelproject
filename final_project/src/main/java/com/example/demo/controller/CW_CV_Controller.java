package com.example.demo.controller;

import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.CWThemeCRUDRequest;
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
    
    // 기본 등록 페이지
    @GetMapping
    public String choose_val_view() {
        return "cw-test/choose_val";
    }

    // 등록 페이지
    @PostMapping
    @ResponseBody
    public ResponseEntity<?> createStudent(
    		@RequestBody CWThemeRequest request
    		) {
    	CWThemeCRUDRequest requestF = new CWThemeCRUDRequest();
    	requestF.setHigh_loc(request.getHigh_loc());
    	if(request.getLow_loc().equals("")) {
    		requestF.setLow_loc("");
    	}else {
    		requestF.setLow_loc(request.getLow_loc());
    	}
    	requestF.setDays(request.getDays());
    	List<String> themes = request.getTheme();
    	for(int idx=0; idx<4; idx+=1) {
    		if(idx==0){
    			requestF.setTheme1(themes.get(idx));
    		}else if(idx==1) {
    			requestF.setTheme2(themes.get(idx));
    		}else if(idx==2) {
    			if(themes.size()<=2) {
    				requestF.setTheme3("");
    			}else {
    				requestF.setTheme3(themes.get(idx));
    			}
    		}else if(idx==3) {
    			if(themes.size()<=3) {
    				requestF.setTheme4("");
    			}else {
    				requestF.setTheme4(themes.get(idx));
    			}
    		}
    	}
    	String message = themeService.insertChooseVal(requestF);
    	
        return ResponseEntity.ok(message);
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
    @ResponseBody
    public ResponseEntity<?> updateStudent(
    		@RequestParam("choose_id") int choose_id,
    		@RequestBody CWThemeCRUDRequest request) {
        String message = themeService.updateChooseVal(choose_id, request);
        return ResponseEntity.ok(message);
    }

    //삭제 페이지
    @DeleteMapping
    @ResponseBody
    public ResponseEntity<?> deleteStudent(
    		@RequestParam("choose_id") int choose_id) {
    	String message = themeService.deleteChooseVal(choose_id);
        return ResponseEntity.ok(message);
    }
    
}

package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_01_AreaListRequest;
import com.example.demo.dto.CWTravelAPI_02_ItemRequest;
import com.example.demo.dto.CWTravelAPI_06_FinalRequest;
import com.example.demo.service.CWTravelAPI_01_Service;

@Controller
public class CWController {

    // 관광 API 값 받는 서비스단
    @Autowired
    private CWTravelAPI_01_Service travelAPI_01_Service;
    
    // 기본 페이지
	@GetMapping("/cwtest")
	public String testpage() {
		return "\\cw-test\\cwAPItest";
	}

	// 요청
    @PostMapping("/cwtestAPIre")
    public String sendMessage(CWThemeRequest theme, Model model) {
    	
    	CWTravelAPI_00_Request tapi_req = new CWTravelAPI_00_Request();
    	String high_loc = theme.getHigh_loc();
    	String low_loc = theme.getLow_loc();
    	List<String> theme1 = theme.getTheme1();
    	List<List> themes = new ArrayList<>();
    	themes.add(theme1);
    	if(theme.getTheme2()!=null) {
    		List<String> theme2 = theme.getTheme2();
        	themes.add(theme2);
    	}
    	if(theme.getTheme3()!=null) {
    		List<String> theme3 = theme.getTheme3();
        	themes.add(theme3);
    	}
    	if(theme.getTheme4()!=null) {
    		List<String> theme4 = theme.getTheme4();
        	themes.add(theme4);
    	}
    	
    	tapi_req.setAreaCodeVal(high_loc);
    	tapi_req.setSigunguCodeVal(low_loc);
    	
    	List<List> responses = new ArrayList<>();
    	
    	for(List<String> th:themes) {
        	for(String t:th) {
        		tapi_req.setCat1Val(t.substring(0, 3));
        		tapi_req.setCat2Val(t.substring(3, 5));
        		
	        	CWTravelAPI_06_FinalRequest response = travelAPI_01_Service.getTravelAPIResponse(tapi_req);
	        	
	        	List<CWTravelAPI_01_AreaListRequest> items = response
	        			.getResponse()
	        			.getBody()
	        			.getItems()
	        			.getItem()
	        			.getArea_list();
	        	
	        	responses.add(items);
        	}
    	}
    	
        model.addAttribute("responses", responses);
        return "\\cw-test\\cwAPItest";
    }
}

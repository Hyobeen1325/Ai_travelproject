package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_01_Item;
import com.example.demo.dto.CWTravelAPI_05_FinalResponse;
import com.example.demo.service.CWTravelAPI_01_Service;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor // final에 자동으로 생성자 만드는 어노테이션
@Controller
public class CWController {

    // 관광 API 값 받는 서비스단
    @Autowired
    private final CWTravelAPI_01_Service travelAPI_01_Service;
    
    // 기본 페이지
	@GetMapping("/cwtest")
	public String testpage() {
		return "/cw-test/cwAPItest";
	}

	// 요청
    @PostMapping("/cwtestAPIre")
    public String sendPrompt(CWThemeRequest theme, Model model) {
    	
    	List<CWTravelAPI_01_Item> areaList = new ArrayList<>();
    	
    	CWTravelAPI_00_Request tapi_req = new CWTravelAPI_00_Request();
    	// 관광 API에 보낼 요청값
    	
    	// 받은 요청값 정제
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
    	
    	int days = theme.getDays();

		CWTravelAPI_05_FinalResponse response;
		
    	if(days>1) { // 당일치기가 아닌 경우 경우
    		tapi_req.setContentTypeIdVal(32); // 숙소 타입의 여행지 탐색
    		
			try {
				response = travelAPI_01_Service.getTravelAPIResponse(tapi_req);

	    		if(response != null &&
	    			    response.getResponse().getBody() != null &&
	    			    response.getResponse().getBody().getItems() != null &&
	    			    response.getResponse().getBody().getItems().getItem() != null) { // 탐색한 값이 null 이 아니면
	        		areaList.addAll(response // 리스트에 추가
	        				.getResponse()
	        				.getBody()
	        				.getItems()
	        				.getItem());
	        	}
			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	
        	tapi_req.setContentTypeIdVal(0); // 검색 후 초기화
    	}
    	
    	for(List<String> th:themes) {
        	for(String t:th) {
        		if(t != null) {
        			if(t.length()==3) {
        				tapi_req.setCat1Val(t);
        			}else if(t.length()==5) {
        				tapi_req.setCat1Val(t.substring(0, 3));
        				tapi_req.setCat2Val(t);
        			}
	
					try {
						response = travelAPI_01_Service.getTravelAPIResponse(tapi_req);

		        		if(response != null &&
		        			    response.getResponse().getBody() != null &&
		        			    response.getResponse().getBody().getItems() != null &&
		        			    response.getResponse().getBody().getItems().getItem() != null) {
		            		areaList.addAll(response
		            				.getResponse()
		            				.getBody()
		            				.getItems()
		            				.getItem());
		            	}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
        		}
        	}
    	}
    	
    	// 중복 제거
        List<CWTravelAPI_01_Item> areaListF = new ArrayList<>(new HashSet<>(areaList));

    	
    	model.addAttribute("areaList", areaListF); // 리스트를 모델에 할당
    	
        return "/cw-test/cwAPIList";
    }
    
}

package com.example.demo.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_06_FinalRequest;

@Service
public class CWTravelAPI_01_Service {
	// 관광API로 리스트를 받는 서비스단

    private final RestTemplate restTemplate = new RestTemplate();
    
    public CWTravelAPI_06_FinalRequest getTravelAPIResponse(
    		CWTravelAPI_00_Request request) {
    	
    	String areaCode = request.getAreaCodeVal();
    	String sigunguCode = request.getSigunguCodeVal();
    	String cat1 = request.getCat1Val();
    	String cat2 = request.getCat2Val();
    	
    	String TravelApiUrl = "http://apis.data.go.kr"+
    			"/B551011/KorService1/areaBasedList1?"+
    			"_type=Json&mobileOS=ETC&MobileApp=APPtest&"+
    			"serviceKey=0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D&"+
    			"pageNo=1&numOfRows=100&"+
    			"areaCode={areaCode}&"+
    			"sigunguCode={sigunguCode}&"+
    			"cat1={cat1}&"+
    			"cat2={cat2}";
    	
        return restTemplate.getForObject(
        		TravelApiUrl,
        		CWTravelAPI_06_FinalRequest.class,
        		areaCode, sigunguCode,
        		cat1, cat2);
    }
}

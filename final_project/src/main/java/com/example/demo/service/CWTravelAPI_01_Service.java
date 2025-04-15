package com.example.demo.service;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_05_FinalResponse;

@Service
public class CWTravelAPI_01_Service {
	// 관광API로 리스트를 받는 서비스단

    private final RestTemplate restTemplate;

    public CWTravelAPI_01_Service(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public CWTravelAPI_05_FinalResponse getTravelAPIResponse(CWTravelAPI_00_Request requestVal) {

    	String areaCode = requestVal.getAreaCodeVal();
    	String sigunguCode = requestVal.getSigunguCodeVal();
    	String cat1 = requestVal.getCat1Val();
    	String cat2 = requestVal.getCat2Val();
    	//String serviceKey = "0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D";
    	
    	String TravelApiUrl = "http://apis.data.go.kr"+
    			"/B551011/KorService1/areaBasedList1?"+
    			"_type=json&"+
    			"mobileOS=ETC&MobileApp=APPtest"+
    			//"&serviceKey=" + serviceKey +
    			"&pageNo=1&numOfRows=100&"+
    			"areaCode="+areaCode+
    			"&sigunguCode="+sigunguCode;
    	
    	if(requestVal.getContentTypeIdVal()==32) {
    		TravelApiUrl+="&contentTypeId=32";

            //System.out.println("restTemplate 들어가기 전 url : "+TravelApiUrl);
            
    		ResponseEntity<CWTravelAPI_05_FinalResponse> responseEntity  = restTemplate.exchange(
				TravelApiUrl,
			    HttpMethod.GET,
			    null, // HttpEntity 생략 가능
			    new ParameterizedTypeReference<>() {}
			);

            //System.out.println("호출된 값 : "+ responseEntity.getBody().getResponse());
            
            return responseEntity.getBody();
            
    	}else {
    		TravelApiUrl += "&cat1="+cat1;
			if(cat2 != null) {
				TravelApiUrl += "&cat2="+cat2;
			}

            //System.out.println("restTemplate 들어가기 전 url : "+TravelApiUrl);

    		ResponseEntity<CWTravelAPI_05_FinalResponse> responseEntity  = restTemplate.exchange(
				TravelApiUrl,
			    HttpMethod.GET,
			    null, // HttpEntity 생략 가능
			    new ParameterizedTypeReference<>() {}
			);

            return responseEntity.getBody();
    	}
    }
}

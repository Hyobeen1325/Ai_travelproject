package com.example.demo.service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RequestCallback;
import org.springframework.web.client.ResponseExtractor;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_04_Response;
import com.fasterxml.jackson.dataformat.xml.XmlMapper;

@Service
public class CWTravelAPI_01_Service {
	// 관광API로 리스트를 받는 서비스단

    @Autowired
    private final RestTemplate restTemplate;
    
    public CWTravelAPI_01_Service(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }
    
    public CWTravelAPI_04_Response getTravelAPIResponse(CWTravelAPI_00_Request requestVal)
    		 throws Exception {

    	RequestCallback requestCallback = request -> {
    	    request.getHeaders().setAccept(Collections.singletonList(MediaType.APPLICATION_XML));
    	    request.getHeaders().set("User-Agent", "Mozilla/5.0");
    	};

    	ResponseExtractor<String> responseExtractor = response -> {
    	    InputStream inputStream = response.getBody();
    	    return new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))
    	            .lines()
    	            .collect(Collectors.joining("\n"));
    	};
        
    	String areaCode = requestVal.getAreaCodeVal();
    	String sigunguCode = requestVal.getSigunguCodeVal();
    	String cat1 = requestVal.getCat1Val();
    	String cat2 = requestVal.getCat2Val();
    	//String serviceKey = "0MHNpRPQr0BonjfZozHtGZWjNLitvGLKjNT%2BW6nBSCYW2Zz7e5ro7gq%2FMRKLoP%2FcNmbAAErU2AgWo2LvLGiIfA%3D%3D";
    	
    	String TravelApiUrl = "http://apis.data.go.kr"+
    			"/B551011/KorService1/areaBasedList1?"+
    			//"_type=json&"+
    			"mobileOS=ETC&MobileApp=APPtest"+
    			//"&serviceKey=" + serviceKey +
    			"&pageNo=1&numOfRows=100&"+
    			"areaCode="+areaCode+
    			"&sigunguCode="+sigunguCode;
    	
    	if(requestVal.getContentTypeIdVal()==32) {
    		TravelApiUrl+="&contentTypeId=32";

            //System.out.println("url : "+TravelApiUrl);
            
            // 외부 API 호출
            String result = restTemplate.execute(
            		TravelApiUrl,
                    HttpMethod.GET,
                    requestCallback,
                    responseExtractor
            );

            System.out.println("XML원문 : "+result );
            
            // 2. XML -> DTO 매핑
            XmlMapper xmlMapper = new XmlMapper();
            CWTravelAPI_04_Response response = xmlMapper.readValue(result, CWTravelAPI_04_Response.class);
            return response; // 응답 반환
            
    	}else {
    		TravelApiUrl += "&cat1="+cat1;
			if(cat2 != null) {
				TravelApiUrl += "&cat2="+cat2;
			}

            //System.out.println("url : "+TravelApiUrl);
            
            // 외부 API 호출
            String result = restTemplate.execute(
            		TravelApiUrl,
                    HttpMethod.GET,
                    requestCallback,
                    responseExtractor
            );

            System.out.println("XML원문 : "+result);

            // 2. XML -> DTO 매핑
            XmlMapper xmlMapper = new XmlMapper();
            CWTravelAPI_04_Response response = xmlMapper.readValue(result, CWTravelAPI_04_Response.class);
            return response; // 응답 반환
    	}
    }
}

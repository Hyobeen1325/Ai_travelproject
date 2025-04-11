package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWTravelAPI_05_ResponseRequest;

@Service
public class CWTravelAPI_02_Service {
	// 관광API로 받은 리스트를 보내 필터링 받는 서비스단
	 @Value("${fastapi.url:http://192.168.0.64:8586}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public CWTravelAPI_02_Service() {
        this.restTemplate = new RestTemplate();
    }

    public String getChatResponse(CWTravelAPI_05_ResponseRequest areaRequest) {
        String url = fastApiUrl + "/cw/areachoose";
        return restTemplate.postForObject(url, areaRequest, CWTravelAPI_02_Response.class).getResponse();
    }
}

class CWTravelAPI_02_Response {
    private String response;

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }
}

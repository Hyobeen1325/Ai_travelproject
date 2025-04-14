package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class CWThemeService {
	// 선택한 테마값 저장하는 서비스단
	 @Value("${fastapi.url:http://192.168.0.64:8586}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public CWThemeService() {
        this.restTemplate = new RestTemplate();
    }

    public String getChatResponse(CWThemeResponse themeRequest) {
        String url = fastApiUrl + "/cw/themechoose";
        return restTemplate.postForObject(url, themeRequest, CWThemeResponse.class).getResponse();
    }
}

class CWThemeResponse {
    private String response;

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }
}

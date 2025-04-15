package com.example.demo.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWThemeResponse;

@Service
public class CWThemeService {
	// 선택한 테마값 저장하는 서비스단
	 @Value("${fastapi.url:http://192.168.0.64:8586}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public CWThemeService() {
        this.restTemplate = new RestTemplate();
    }

    // 선택값 등록
    public CWThemeResponse insertChooseVal(CWThemeRequest themeRequest) {
        return restTemplate.postForObject(fastApiUrl + "/choose_val", themeRequest, CWThemeResponse.class);
    }

    // 선택값 전체 조회
    public List<CWThemeResponse> gatAllChooseVal() {
    	CWThemeResponse[] choose_vals = restTemplate.getForObject(fastApiUrl + "/choose_vals", CWThemeResponse[].class);
    	return Arrays.asList(choose_vals);
    }

    // 선택값 단일조회
    public CWThemeResponse getChooseValById(int choose_id) {
        return restTemplate.getForObject(fastApiUrl + "/choose_val/" + choose_id, CWThemeResponse.class);
    }

    // 선택값 수정
    public CWThemeResponse updateChooseVal(int choose_id, CWThemeRequest themeRequest) {
    	restTemplate.put(fastApiUrl + "/choose_val/" + choose_id, themeRequest);
    	return getChooseValById(choose_id);
    }

    // 선택값 삭제
    public String deleteChooseVal(int choose_id) {
    	restTemplate.delete(fastApiUrl + "/choose_val/" + choose_id);
        return "Deleted choose_val with ID: " + choose_id;
    }

}

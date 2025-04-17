package com.example.demo.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.CWThemeCRUDRequest;
import com.example.demo.dto.CWThemeResponse;

@Service
public class CWThemeService {
	// 선택한 테마값 저장하는 서비스단
	 @Value("${fastapi.url:http://192.168.0.64:8000}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public CWThemeService() {
        this.restTemplate = new RestTemplate();
    }

    // 선택값 등록
    public String insertChooseVal(CWThemeCRUDRequest themeRequest) {
    	CWThemeResponse response = restTemplate.postForObject(fastApiUrl + "/choose_val", themeRequest, CWThemeResponse.class);
    	
    	return response!=null?"등록 성공":"등록 실패";
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
    public String updateChooseVal(int choose_id, CWThemeCRUDRequest themeRequest) {
    	restTemplate.put(fastApiUrl + "/choose_val/" + choose_id, themeRequest);
    	CWThemeResponse response = getChooseValById(choose_id);
    	return response!=null?"수정 성공":"수정 실패";
    }

    // 선택값 삭제
    public String deleteChooseVal(int choose_id) {
    	restTemplate.delete(fastApiUrl + "/choose_val/" + choose_id);
    	try {
    		CWThemeResponse choose_val = getChooseValById(choose_id);
    		return "삭제실패\n 삭제정보 조회됨";
		} catch (HttpClientErrorException e) {
			return "삭제 성공\n삭제된 선택값 ID: " + choose_id;
		} catch (Exception e) {
			return "삭제실패\n 사유: "+e.getMessage();
		}
    }

}

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
    	try {
    		restTemplate.postForObject(fastApiUrl + "/choose_val", themeRequest, CWThemeResponse.class);
    		return "등록성공";
		} catch (Exception e) {
			return "등록실패\n 사유: "+e.getMessage();
		}
    }

    // 선택값 전체 조회
    public List<CWThemeResponse> gatAllChooseVal() {
    	CWThemeResponse[] choose_vals = restTemplate.getForObject(fastApiUrl + "/choose_vals", CWThemeResponse[].class);
    	return Arrays.asList(choose_vals);
    }

    // 선택값 단일조회
    public CWThemeResponse getChooseValById(int choose_id) {
    	try {
    		return restTemplate.getForObject(fastApiUrl + "/choose_val/" + choose_id, CWThemeResponse.class);
		} catch (HttpClientErrorException e) {
			CWThemeResponse noFind = new CWThemeResponse();
			noFind.setHigh_loc("해당 ID의 선택값은 없음");
			return noFind;
		} catch (Exception e) {
			CWThemeResponse faile = new CWThemeResponse();
			faile.setHigh_loc("탐색실패");
			faile.setLow_loc(e.getMessage());
			return faile;
		}
    }

    // 선택값 수정
    public String updateChooseVal(int choose_id, CWThemeCRUDRequest themeRequest) {
    	try {
    		restTemplate.put(fastApiUrl + "/choose_val/" + choose_id, themeRequest);
    		return "수정성공";
		} catch (Exception e) {
			return "수정실패\n 사유: "+e.getMessage();
		}
    }

    // 선택값 삭제
    public String deleteChooseVal(int choose_id) {

    	try {
	    	restTemplate.delete(fastApiUrl + "/choose_val/" + choose_id);
	    	try {
	    		getChooseValById(choose_id);
	    		return "삭제실패\n 삭제정보 조회됨";
			} catch (HttpClientErrorException e) {
				return "삭제 성공\n삭제된 선택값 ID: " + choose_id;
			} catch (Exception e) {
				return "삭제실패\n 사유: "+e.getMessage();
			}
		} catch (Exception e) {
			return "삭제실패\n 사유: "+e.getMessage();
		}
    }

}

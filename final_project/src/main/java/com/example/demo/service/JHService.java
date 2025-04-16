package com.example.demo.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHRequestDto2;
import com.example.demo.dto.JHResponseDto;
import com.example.demo.dto.JHResponseDto2;

@Service
public class JHService {

    @Value("${fastapi.url:http://localhost:8000}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public JHService() {
        this.restTemplate = new RestTemplate();
    }

    public JHResponseDto getJHResponse(JHRequestDto chatRequest) {
        String url = fastApiUrl + "/page04/message";

        // FastAPI에 POST 요청
        JHResponseDto result = restTemplate.postForObject(url, chatRequest, JHResponseDto.class);

        if (result == null) {
            JHResponseDto emptyResult = new JHResponseDto();
            emptyResult.setResponse("FastAPI 응답 없음");
            return emptyResult;
        }

        // 응답 문자열 가공
        String processed = processResponse(result.getResponse());
        result.setResponse(processed); // 가공한 response로 덮어쓰기

        return result;
    }
    public Map<String, Object> getJHResponse2(JHRequestDto2 chatRequest) {
        String url = fastApiUrl + "/page3/message";

        JHResponseDto2 result = restTemplate.postForObject(url, chatRequest, JHResponseDto2.class);

        if (result == null) {
            result = new JHResponseDto2();
            result.setResponse("응답 없음");
            result.setLatitude(null);
            result.setLongitude(null);
        } else {
            String processedResponse = processResponse(result.getResponse());
            result.setResponse(processedResponse);
        }

        Map<String, Object> responseMap = new HashMap<>();
        responseMap.put("response", result.getResponse());
        responseMap.put("latitude", result.getLatitude());
        responseMap.put("longitude", result.getLongitude());
        responseMap.put("titles", result.getTitle() != null ? result.getTitle() : new ArrayList<>());
        responseMap.put("upt_dates", result.getUpt_date() != null ? result.getUpt_date() : new ArrayList<>());
        responseMap.put("questions", result.getQuestion() != null ? result.getQuestion() : new ArrayList<>());
        responseMap.put("answers", result.getAnswer() != null ? result.getAnswer() : new ArrayList<>());

        return responseMap;
    }

    
    private String processResponse(String response) {
        if (response == null || response.isBlank()) {
            return "FastAPI로부터 받은 유효한 응답이 없습니다.";
        }

        // 불필요한 공백 제거
        String trimmed = response.trim();

        // 줄바꿈 처리 (HTML에서 출력하기 위함)
        String withLineBreaks = trimmed.replace("\n", "<br>");

        // 추가 예시: 특정 키워드 강조
        withLineBreaks = withLineBreaks.replaceAll("추천", "<strong>추천</strong>");

        return withLineBreaks;
    }


}


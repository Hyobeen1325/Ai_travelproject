package com.example.demo.service;

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

    public String getJHResponse(JHRequestDto chatRequest) {
        String url = fastApiUrl + "/page04/message";

        // FastAPI에 요청
        JHResponseDto result = restTemplate.postForObject(url, chatRequest, JHResponseDto.class);

        // 응답 처리
        String rawResponse = result != null ? result.getResponse() : "응답 없음";

        // 여기서 가공 처리 시작
        String processedResponse = processResponse(rawResponse);

        return processedResponse;
    }

    public String getJHResponse2(JHRequestDto2 chatRequest) {
        String url = fastApiUrl + "/page3/message";

        // FastAPI에 요청
        JHResponseDto2 result = restTemplate.postForObject(url, chatRequest, JHResponseDto2.class);

        // null 체크 및 기본 처리
        if (result == null) {
            result = new JHResponseDto2();
            result.setResponse("응답 없음");
            result.setLatitude(null);
            result.setLongitude(null);
        } else {
            // 필요한 경우 응답 문자열 전처리
            String processedResponse = processResponse(result.getResponse());
            result.setResponse(processedResponse);
        }

        // 응답을 String으로 변환하여 반환
        String responseText = result.getResponse();
        Double latitude = result.getLatitude();
        Double longitude = result.getLongitude();

        // 문자열로 결합하여 반환
        StringBuilder responseBuilder = new StringBuilder();
        responseBuilder.append("{")
                .append("\"response\": \"").append(responseText).append("\", ")
                .append("\"latitude\": ").append(latitude != null ? latitude : "null").append(", ")
                .append("\"longitude\": ").append(longitude != null ? longitude : "null")
                .append("}");

        return responseBuilder.toString();
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


package com.example.demo.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHResponse;

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
        JHResponse result = restTemplate.postForObject(url, chatRequest, JHResponse.class);

        // 응답 처리
        String rawResponse = result != null ? result.getResponse() : "응답 없음";

        // 여기서 가공 처리 시작
        String processedResponse = processResponse(rawResponse);

        return processedResponse;
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


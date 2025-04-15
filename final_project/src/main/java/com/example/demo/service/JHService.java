package com.example.demo.service;

import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHResponseDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class JHService {

    @Value("${fastapi.url:http://localhost:8000}")
    private String fastApiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    // 기존 텍스트 응답 메서드
    public String getJHResponse(JHRequestDto requestDto) {
        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(
                fastApiUrl + "/page04/message",
                requestDto,
                (Class<Map<String, Object>>) (Class<?>) Map.class
            );

            Map<String, Object> responseBody = response.getBody();
            if (responseBody != null && responseBody.containsKey("response")) {
                return (String) responseBody.get("response");
            }
        } catch (RestClientException e) {
            e.printStackTrace();
            return "AI 응답 중 오류가 발생했습니다.";
        }
        return "AI 응답이 비어 있습니다.";
    }

    // 위치 정보 포함 응답 메서드
    public JHResponseDto getJHResponseWithLocation(JHRequestDto requestDto) {
        JHResponseDto responseDto = new JHResponseDto();

        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.postForEntity(
                fastApiUrl + "/page04/message",
                requestDto,
                (Class<Map<String, Object>>) (Class<?>) Map.class
            );

            Map<String, Object> responseBody = response.getBody();
            if (responseBody != null) {
                responseDto.setResponse((String) responseBody.get("response"));
                if (responseBody.containsKey("location")) {
                    responseDto.setLocation((String) responseBody.get("location"));
                }
            } else {
                responseDto.setResponse("AI 응답이 없습니다.");
            }
        } catch (RestClientException e) {
            e.printStackTrace();
            responseDto.setResponse("AI 호출 중 오류가 발생했습니다.");
        }

        return responseDto;
    }
}
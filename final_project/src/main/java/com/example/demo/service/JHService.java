package com.example.demo.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpServerErrorException;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.JHRequestDto;
import com.example.demo.dto.JHRequestDto2;
import com.example.demo.dto.JHRequestDto3;
import com.example.demo.dto.JHResponseDto;
import com.example.demo.dto.JHResponseDto2;
import com.example.demo.dto.JHResponseDto3;

@Service
public class JHService {

    @Value("${fastapi.url:http://localhost:8000}")
    private String fastApiUrl;

    private final RestTemplate restTemplate;

    public JHService() {
        this.restTemplate = new RestTemplate();
        MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
        converter.setSupportedMediaTypes(Arrays.asList(MediaType.APPLICATION_JSON));
        restTemplate.getMessageConverters().add(0, converter);
    }

    public Map<String, Object> getJHResponse(JHRequestDto chatRequest) {
        String url = fastApiUrl + "/page04/message";
        try {
            ResponseEntity<JHResponseDto> response = restTemplate.postForEntity(
                url,
                chatRequest,
                JHResponseDto.class
            );

            JHResponseDto result = response.getBody();
            if (result == null) {
                result = new JHResponseDto();
                result.setResponse("FastAPI 응답 없음");
            } else {
                String processedResponse = processResponse(result.getResponse());
                result.setResponse(processedResponse);
            }

            return buildResponseMap(result);

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "클라이언트 에러: " + e.getMessage());
            return errorMap;
        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "서버 에러: " + e.getMessage());
            return errorMap;
        } catch (Exception e) {
            System.err.println("Error calling FastAPI: " + e.getMessage());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "FastAPI 호출 중 에러 발생: " + e.getMessage());
            return errorMap;
        }
    }

    public Map<String, Object> getJHResponse2(JHRequestDto2 chatRequest) {
        String url = fastApiUrl + "/page3/message";
        try {
            ResponseEntity<JHResponseDto2> response = restTemplate.postForEntity(
                url,
                chatRequest,
                JHResponseDto2.class
            );

            JHResponseDto2 result = response.getBody();
            if (result == null) {
                result = new JHResponseDto2();
                result.setResponse("FastAPI 응답 없음");
                result.setLatitude(null);
                result.setLongitude(null);
            } else {
                String processedResponse = processResponse(result.getResponse());
                result.setResponse(processedResponse);
            }

            Map<String, Object> responseMap = buildResponseMap(result);
            responseMap.put("latitude", result.getLatitude());
            responseMap.put("longitude", result.getLongitude());
            
            return responseMap;

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "클라이언트 에러: " + e.getMessage());
            return errorMap;
        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "서버 에러: " + e.getMessage());
            return errorMap;
        } catch (Exception e) {
            System.err.println("Error calling FastAPI: " + e.getMessage());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "FastAPI 호출 중 에러 발생: " + e.getMessage());
            return errorMap;
        }
    }
    public Map<String, Object> getJHResponse3(JHRequestDto3 chatRequest) {
        String url = fastApiUrl + "/page5/message";
        try {
            ResponseEntity<JHResponseDto3> response = restTemplate.postForEntity(
                url,
                chatRequest,
                JHResponseDto3.class
            );

            JHResponseDto3 result = response.getBody();
            if (result == null) {
                result = new JHResponseDto3();
                result.setResponse("FastAPI 응답 없음");
            } else {
                String processedResponse = processResponse(result.getResponse());
                result.setResponse(processedResponse);
            }

            return buildResponseMap(result);

        } catch (HttpClientErrorException e) {
            System.err.println("Client error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "클라이언트 에러: " + e.getMessage());
            return errorMap;
        } catch (HttpServerErrorException e) {
            System.err.println("Server error: " + e.getResponseBodyAsString());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "서버 에러: " + e.getMessage());
            return errorMap;
        } catch (Exception e) {
            System.err.println("Error calling FastAPI: " + e.getMessage());
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("response", "FastAPI 호출 중 에러 발생: " + e.getMessage());
            return errorMap;
        }
    }
    private String processResponse(String response) {
        if (response == null || response.isBlank()) {
            return "FastAPI로부터 받은 유효한 응답이 없습니다.";
        }
        String trimmed = response.trim();
        String withLineBreaks = trimmed.replace("\\n", "<br>");
        withLineBreaks = withLineBreaks.replaceAll("추천", "<strong>추천</strong>");
        return withLineBreaks;
    }

    private Map<String, Object> buildResponseMap(Object result) {
        Map<String, Object> responseMap = new HashMap<>();

        if (result instanceof JHResponseDto dto) {
            responseMap.put("response", dto.getResponse());

            if (dto.getChatLogs() != null) {
                responseMap.put("chatLogs", dto.getChatLogs());
            }
            if (dto.getQnaData() != null) {
                responseMap.put("qnaData", dto.getQnaData());
            }
            if (dto.getQuestions() != null) {
                responseMap.put("questions", dto.getQuestions());
            }
            if (dto.getAnswers() != null) {
                responseMap.put("answers", dto.getAnswers());
            }
            if (dto.getTitles() != null && dto.getUptDates() != null) {
                // getUpt_dates()가 이미 List<Date>를 반환한다고 가정
                List<Date> Upt_dates = dto.getUptDates();
                List<ChatLogItemDto> chatList = buildChatLogList(dto.getTitles(), Upt_dates);
                responseMap.put("chatList", chatList);
            }

        } else if (result instanceof JHResponseDto2 dto) {
            responseMap.put("response", dto.getResponse());
            if (dto.getLatitude() != null) {
                responseMap.put("latitude", dto.getLatitude());
            }
            if (dto.getLongitude() != null) {
                responseMap.put("longitude", dto.getLongitude());
            }
            if (dto.getChatLogs() != null) {
                responseMap.put("chatLogs", dto.getChatLogs());
            }
            if (dto.getQnaData() != null) {
                responseMap.put("qnaData", dto.getQnaData());
            }
            if (dto.getQuestions() != null) {
                responseMap.put("questions", dto.getQuestions());
            }
            if (dto.getAnswers() != null) {
                responseMap.put("answers", dto.getAnswers());
            }
            if (dto.getTitles() != null && dto.getUptDates() != null) {
                List<ChatLogItemDto> chatList = buildChatLogList(dto.getTitles(), dto.getUptDates());
                responseMap.put("chatList", chatList);
            }
        }else if (result instanceof JHResponseDto3 dto) {
            responseMap.put("response", dto.getResponse());    
            if (dto.getChatLogs() != null) {
                responseMap.put("chatLogs", dto.getChatLogs());
            }
            if (dto.getQnaData() != null) {
                responseMap.put("qnaData", dto.getQnaData());
            }
            if (dto.getQuestions() != null) {
                responseMap.put("questions", dto.getQuestions());
            }
            if (dto.getAnswers() != null) {
                responseMap.put("answers", dto.getAnswers());
            }
            if (dto.getTitles() != null && dto.getUptDates() != null) {
                List<ChatLogItemDto> chatList = buildChatLogList(dto.getTitles(), dto.getUptDates());
                responseMap.put("chatList", chatList);
            }
        }

        return responseMap;
    }

    private List<ChatLogItemDto> buildChatLogList(List<String> titles, List<Date> Upt_dates) {
        List<ChatLogItemDto> chatList = new ArrayList<>();

        if (Upt_dates != null) {
            for (int i = 0; i < Upt_dates.size(); i++) {
                ChatLogItemDto item = new ChatLogItemDto();
                item.setUpt_date(Upt_dates.get(i)); // Date 타입 그대로 설정
                item.setTitle(titles != null && i < titles.size() ? titles.get(i) : "");
                chatList.add(item);
            }
        } else if (titles != null) {
            // Upt_dates가 null일 경우 titles를 기준으로 순회 (Upt_date는 null로 처리)
            for (int i = 0; i < titles.size(); i++) {
                ChatLogItemDto item = new ChatLogItemDto();
                item.setTitle(titles.get(i));
                item.setUpt_date(null);
                chatList.add(item);
            }
        }

        return chatList;
    }

    private Date parseDate(String dateString) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); // 날짜 형식에 맞춰 수정
        try {
            return sdf.parse(dateString);
        } catch (ParseException e) {
            System.err.println("날짜 파싱 오류: " + dateString + " - " + e.getMessage());
            return null;
        }
    }
}

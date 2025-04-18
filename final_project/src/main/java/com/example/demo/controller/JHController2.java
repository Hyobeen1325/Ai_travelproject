package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_01_Item;
import com.example.demo.dto.CWTravelAPI_05_FinalResponse;
import com.example.demo.dto.JHRequestDto2;
import com.example.demo.dto.QnaItemDto;
import com.example.demo.service.CWTravelAPI_01_Service;
import com.example.demo.service.JHService;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class JHController2 {

    @Autowired
    private final CWTravelAPI_01_Service travelAPI_01_Service;

    @Autowired
    private final JHService jhService;

    @PostMapping("/combinedAreaAI")
    public String handleCombinedRequest(CWThemeRequest theme, Model model) {
        List<CWTravelAPI_01_Item> areaList = new ArrayList<>();
        CWTravelAPI_00_Request tapi_req = new CWTravelAPI_00_Request();

        String high_loc = theme.getHigh_loc();
        String low_loc = theme.getLow_loc();
        List<String> themes = theme.getTheme();
        int days = theme.getDays();

        tapi_req.setAreaCodeVal(high_loc);
        tapi_req.setSigunguCodeVal(low_loc);

        CWTravelAPI_05_FinalResponse response;

        if (days > 1) {
            tapi_req.setContentTypeIdVal(32);
            try {
                response = travelAPI_01_Service.getTravelAPIResponse(tapi_req);
                if (response != null &&
                        response.getResponse().getBody() != null &&
                        response.getResponse().getBody().getItems() != null &&
                        response.getResponse().getBody().getItems().getItem() != null) {
                    areaList.addAll(response.getResponse().getBody().getItems().getItem());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            tapi_req.setContentTypeIdVal(0);
        }

        for (String t : themes) {
            if (t != null) {
                if (t.length() == 3) {
                    tapi_req.setCat1Val(t);
                } else if (t.length() == 5) {
                    tapi_req.setCat1Val(t.substring(0, 3));
                    tapi_req.setCat2Val(t);
                }

                try {
                    response = travelAPI_01_Service.getTravelAPIResponse(tapi_req);
                    if (response != null &&
                            response.getResponse().getBody() != null &&
                            response.getResponse().getBody().getItems() != null &&
                            response.getResponse().getBody().getItems().getItem() != null) {
                        areaList.addAll(response.getResponse().getBody().getItems().getItem());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }

        // ✅ 중복 제거
        List<CWTravelAPI_01_Item> areaListF = new ArrayList<>(new HashSet<>(areaList));
        model.addAttribute("areaList", areaListF);

        // ✅ areaList 기반 질문 생성
        StringBuilder queryBuilder = new StringBuilder("다음 여행지 중에서 추천 코스를 알려줘: ");
        for (CWTravelAPI_01_Item item : areaListF) {
            if (item.getTitle() != null && !item.getTitle().isEmpty()) {
                queryBuilder.append(item.getTitle()).append(", ");
            }
        }
        String query = queryBuilder.toString().replaceAll(", $", "");

        // ✅ AI에 질문 보내기
        JHRequestDto2 requestDto = new JHRequestDto2();
        requestDto.setMessage(query);

        try {
            var resultMap = jhService.getJHResponse2(requestDto);

            model.addAttribute("query2", query);
            model.addAttribute("aiResponse2", resultMap.get("response"));
            model.addAttribute("latitude", resultMap.get("latitude"));
            model.addAttribute("longitude", resultMap.get("longitude"));

            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatList");
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaList");

            model.addAttribute("chatList", chatList);
            model.addAttribute("qnaList", qnaList);

        } catch (Exception e) {
            model.addAttribute("aiResponse2", "응답 처리 중 오류 발생");
            model.addAttribute("latitude", null);
            model.addAttribute("longitude", null);
        }

        return "page04"; // 결과 출력 페이지
    }
}

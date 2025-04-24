package com.example.demo.controller;

import java.time.LocalDate;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.demo.dto.CWThemeRequest;
import com.example.demo.dto.CWTravelAPI_00_Request;
import com.example.demo.dto.CWTravelAPI_01_Item;
import com.example.demo.dto.CWTravelAPI_02_FinalItems;
import com.example.demo.dto.CWTravelAPI_05_FinalResponse;
import com.example.demo.dto.ChatLogItemDto;
import com.example.demo.dto.JHRequestDto2;
import com.example.demo.dto.MemberDTO;
import com.example.demo.dto.QnaItemDto;
import com.example.demo.service.CWTravelAPI_01_Service;
import com.example.demo.service.JHService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.constraints.Email;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Controller
public class JHController2 {

    @Autowired
    private final CWTravelAPI_01_Service travelAPI_01_Service;

    @Autowired
    private final JHService jhService;
   @GetMapping("/combinedAreaAI")
    public String relogin(HttpSession session) {
    	MemberDTO member = (MemberDTO) session.getAttribute("SessionMember");
    	String email = null;
    	if(member != null) {
        email = member.getEmail();
    	} 
    	if(email != null) {
    		return "project1";
    	}
    	else {
    		return "login";
    	}
    	
    }
    @PostMapping("/combinedAreaAI")
    public String handleCombinedRequest(
    		CWThemeRequest theme,
    		Model model, HttpSession session) {
        List<CWTravelAPI_01_Item> areaList = new ArrayList<>();
        CWTravelAPI_00_Request tapi_req = new CWTravelAPI_00_Request();
        
        MemberDTO member = (MemberDTO) session.getAttribute("SessionMember");
        String email = member.getEmail();
        
        String high_loc2 = theme.getHigh_locS();
        String low_locS = "";
    	if(!theme.getLow_locS().equals("")) {
            low_locS = theme.getLow_locS();
    	}

        String high_loc = theme.getHigh_loc();
        String low_loc = theme.getLow_loc();
        
        List<String> themes = theme.getTheme();
        List<String> themeSs = theme.getThemeS();
        
        String theme1 = "";
        String theme2 = "";
        String theme3 = "";
        String theme4 = "";
        
        System.out.println(themeSs.size());
        
        for(int idx=0; idx<4; idx+=1) {
    		if(idx==0){
    			theme1 = themeSs.get(0);
    		}else if(idx==1) {
    			theme2 = themeSs.get(1);
    		}else if(idx==2) {
    			if(themeSs.size()<3) {
    				theme3 = "";
    			}else {
    				theme3 = themeSs.get(2);
    			}
    		}else if(idx==3) {
    			if(themeSs.size()<4) {
    				theme4 = "";
    			}else {
    				theme4 = themeSs.get(3);
    			}
    		}
        }
        
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
        // model.addAttribute("areaList", areaListF);

        // ✅ areaList 기반 질문 생성
        /*
        StringBuilder queryBuilder = new StringBuilder("다음 여행지 중에서 추천 코스를 알려줘: ");
        for (CWTravelAPI_01_Item item : areaListF) {
        	queryBuilder.append(" - title: ").append(item.getTitle()).append("\n");
            queryBuilder.append(" - addr1: ").append(item.getAddr1()).append("\n");
            queryBuilder.append(" - addr2: ").append(item.getAddr2()).append("\n");
            queryBuilder.append(" - contenttypeid: ").append(item.getContenttypeid()).append("\n");
            queryBuilder.append(" - firstimage: ").append(item.getFirstimage()).append("\n");
            queryBuilder.append(" - firstimage2: ").append(item.getFirstimage2()).append("\n");
            queryBuilder.append(" - mapx: ").append(item.getMapx()).append("\n");
            queryBuilder.append(" - mapy: ").append(item.getMapy()).append("\n");
            queryBuilder.append(" - tel: ").append(item.getTel()).append("\n");
            queryBuilder.append("\n"); // 항목 간 줄바꿈
        }
        
        String query = queryBuilder.toString().replaceAll(", $", "");
        
        */

		ObjectMapper mapper = new ObjectMapper();
		String query;
		try {
			query = mapper.writeValueAsString(areaListF);
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
			query = "데이터리스트 Json변환 실패";
			System.out.println(e.getMessage());
		} catch (Exception e) {
			query = "알 수 없는 오류";
			System.out.println(e.getMessage());
		}
        query = query+"날짜:"+days;

        // ✅ AI에 질문 보내기
        JHRequestDto2 requestDto = new JHRequestDto2();
        requestDto.setMessage(query);
        requestDto.setEmail(email);
        requestDto.setHigh_loc2(high_loc2);
        
        requestDto.setLow_loc(low_locS);
        requestDto.setTheme1(theme1);
        requestDto.setTheme2(theme2);
        requestDto.setTheme3(theme3);
        requestDto.setTheme4(theme4);
        requestDto.setDays(days);
        
        try {
            var resultMap = jhService.getJHResponse2(requestDto);
            String areaListSJ = (String) resultMap.get("response");
            //System.out.println(areaListSJ);
            session.setAttribute("aiResponse2", resultMap.get("response"));

			Pattern pattern = Pattern.compile("\\{.*}", Pattern.DOTALL);
			Matcher matcher = pattern.matcher(areaListSJ);
			
			String areaListJ = matcher.find() ? matcher.group() : null;
            
			// DTO로 변환
			if (areaListJ != null) {
				CWTravelAPI_02_FinalItems areaListO = mapper.readValue(areaListJ, CWTravelAPI_02_FinalItems.class);
				//System.out.println(areaListO.getItems().getItem().get(0).getTitle());
				//System.out.println(areaListO.getItems().getItem().get(0).getMapx());
				//System.out.println(areaListO.getItems().getItem().get(0).getMapy());
				List<CWTravelAPI_01_Item> areaListOF = areaListO.getItems().getItem();
	            model.addAttribute("areaListO", areaListOF);
	            session.setAttribute("areaListO", areaListOF);
			}

            session.setAttribute("latitude", resultMap.get("latitude"));
            session.setAttribute("longitude", resultMap.get("longitude"));
            
            model.addAttribute("query2", query);
            //model.addAttribute("aiResponse2", resultMap.get("response"));
            //model.addAttribute("latitude", resultMap.get("latitude"));
            //model.addAttribute("longitude", resultMap.get("longitude"));

            List<ChatLogItemDto> chatList = (List<ChatLogItemDto>) resultMap.get("chatLogs");
            List<QnaItemDto> qnaList = (List<QnaItemDto>) resultMap.get("qnaData");

            model.addAttribute("chatList", chatList);
            model.addAttribute("qnaList", qnaList);
            List<String> dateLabels = new ArrayList<>();
            LocalDate today = LocalDate.now();  // 오늘 날짜

            // chatList가 List<Item> 형태라고 가정
            for (ChatLogItemDto item : chatList) {
                // item에서 upt_date 가져오기 (Date 형태)
                Date upt_date = item.getUpt_date(); // 단일 Date

                if (upt_date == null) {
                    dateLabels.add("알 수 없음");
                    continue;
                }

                // Date를 LocalDate로 변환
                LocalDate date = upt_date.toInstant()
                                         .atZone(ZoneId.systemDefault())
                                         .toLocalDate();

                // 날짜 비교
                long daysBetween = ChronoUnit.DAYS.between(date, today);

                if (daysBetween == 0) {
                    dateLabels.add("오늘");
                } else if (daysBetween == 1) {
                    dateLabels.add("어제");
                } else if (daysBetween <= 7) {
                    dateLabels.add("최근 7일간");
                } else if (daysBetween <= 30) {
                    dateLabels.add("최근 1달");
                } else {
                    dateLabels.add("최근 1달 이후");
                }
            }
            model.addAttribute("dateLabels", dateLabels);

        } catch (Exception e) {
            model.addAttribute("aiResponse2", "응답 처리 중 오류 발생");
            model.addAttribute("latitude", null);
            model.addAttribute("longitude", null);
        }

        return "page05"; // 결과 출력 페이지
    }
}
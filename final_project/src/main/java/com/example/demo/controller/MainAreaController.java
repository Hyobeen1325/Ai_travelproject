package com.example.demo.controller;

import com.example.demo.dto.AreaResponse;
import com.example.demo.dto.Item;
import jakarta.xml.bind.JAXBContext;
import jakarta.xml.bind.Unmarshaller;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.converter.StringHttpMessageConverter;
import java.nio.charset.StandardCharsets;

import java.io.StringReader;
import java.net.URI;
import java.util.Collections;
import java.util.List;

@Controller
@RequestMapping("/mainarea")
public class MainAreaController {
 //http://localhost:8080/mainarea/regions?numOfRows=20
    private static final Logger logger = LoggerFactory.getLogger(MainAreaController.class);

    @GetMapping("/regions")
    public String getSubregions(@RequestParam(value = "numOfRows", defaultValue = "1") int numOfRows, Model model) {
        try {
            String serviceKey = "zobQk13tnvYbo%2Fm%2Ff73cuxwgSffsJEm60Y%2FpBKm2hjfetSQd55bSILGX1Nq9vBi9PEGinACney4ZcjXkgXWL4A%3D%3D"; // 실제 서비스 키로 교체
            String apiUrl = "https://apis.data.go.kr/B551011/KorService1/areaCode1?serviceKey="
                   + serviceKey + "&MobileApp=AppTest&MobileOS=ETC&pageNo=1&numOfRows=" + numOfRows;

           logger.info("API URL: {}", apiUrl);

           URI uri = new URI(apiUrl);
           RestTemplate restTemplate = new RestTemplate();
           restTemplate.getMessageConverters()
           .add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
           String xmlResponse = restTemplate.getForObject(uri, String.class);

           logger.info("API Response: {}", xmlResponse);

            // XML을 DTO로 변환
            JAXBContext jaxbContext = JAXBContext.newInstance(AreaResponse.class);
            Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
            StringReader reader = new StringReader(xmlResponse);
            AreaResponse areaResponse = (AreaResponse) unmarshaller.unmarshal(reader);

            // Items에서 Item 리스트 추출
            List<Item> items = (areaResponse.getBody() != null && areaResponse.getBody().getItems() != null)
                    ? areaResponse.getBody().getItems().getItem()
                    : Collections.emptyList();

            logger.info("Parsed Items: {}", items);

            // 모델에 데이터 추가
            model.addAttribute("items", items);
            model.addAttribute("numOfRows", numOfRows);

            // JSP 뷰 이름 반환
            return "mainarea"; // 기존 JSP 파일 이름에 맞춤
        } catch (Exception e) {
            logger.error("Error fetching subregions", e);
            model.addAttribute("error", "데이터를 불러오는 데 실패했습니다: " + e.getMessage());
            return "mainarea";
        }
        
    }
}
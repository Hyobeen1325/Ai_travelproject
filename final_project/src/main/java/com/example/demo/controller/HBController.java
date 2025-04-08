package com.example.demo.controller;

import java.net.URI;
import java.nio.charset.Charset;

import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@RestController
@RequestMapping("/naver")
public class HBController {
	
	@GetMapping(value = "/search", produces = "application/json; charset=UTF-8")
	public ResponseEntity<String> naverSearchList(@RequestParam(name = "text") String text){
	
		// 네이버 검색 API 클라이언트 ID
		String clientId = "sqsj_8TTbKbdZnIEOa23";
		String clientSecret = "N8E4Lq_uhg";
		
		URI uri = UriComponentsBuilder
				.fromUriString("https://openapi.naver.com")
				.path("/v1/search/local.json")
				.queryParam("query", text)
				.queryParam("display", 1)
				.queryParam("start", 1)
				.queryParam("sort", "random")
				.encode(Charset.forName("UTF-8"))
				.build()
				.toUri();
		
		RequestEntity<Void> req = RequestEntity
				.get(uri)
				.header("X-Naver-Client-Id", clientId)
				.header("X-Naver-Client-Secret", clientSecret)
				.header("Content-Type", "application/json; charset=UTF-8")
				.build();
		
		RestTemplate restTemplate = new RestTemplate();
		
		ResponseEntity<String> responseEntity = restTemplate.exchange(req, String.class);
		
		String responseBody = responseEntity.getBody();
		
		return ResponseEntity.ok(responseBody);
	}
}

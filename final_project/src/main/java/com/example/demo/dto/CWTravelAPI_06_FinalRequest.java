package com.example.demo.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWTravelAPI_06_FinalRequest {
	
	@JsonProperty("response")
	private CWTravelAPI_05_ResponseRequest response;

}

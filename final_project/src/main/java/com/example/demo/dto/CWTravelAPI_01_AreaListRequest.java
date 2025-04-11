package com.example.demo.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWTravelAPI_01_AreaListRequest {
	
	// 관광 API에서 받아 LLM에게 전달하고 다시 받을 값들
	@JsonProperty("addr1")
	private String addr1;
	
	@JsonProperty("addr2")
	private String addr2;
	
	@JsonProperty("areacode")
	private String areacode;
	
	@JsonProperty("booktout")
	private String booktout;
	
	@JsonProperty("cat1")
	private String cat1;
	
	@JsonProperty("cat2")
	private String cat2;

	@JsonProperty("cat3")
	private String cat3;

	@JsonProperty("contentid")
	private String contentid;

	@JsonProperty("contenttypeid")
	private String contenttypeid;

	@JsonProperty("createdtime")
	private String createdtime;

	@JsonProperty("firstimage")
	private String firstimage;

	@JsonProperty("firstimage2")
	private String firstimage2;

	@JsonProperty("cpyrhtDivCd")
	private String cpyrhtDivCd;

	@JsonProperty("mapx")
	private String mapx;

	@JsonProperty("mapy")
	private String mapy;

	@JsonProperty("mlevel")
	private String mlevel;

	@JsonProperty("modifiedtime")
	private String modifiedtime;

	@JsonProperty("sigungucode")
	private String sigungucode;

	@JsonProperty("tel")
	private String tel;

	@JsonProperty("title")
	private String title;

	@JsonProperty("zipcode")
	private String zipcode;
}

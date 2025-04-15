package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWTravelAPI_01_Item {
	
	// 관광 API에서 받아 LLM에게 전달하고 다시 받을 값들
	private String addr1;
	private String addr2;
	private String areacode;
	private String booktout;
	private String cat1;
	private String cat2;
	private String cat3;
	private String contentid;
	private String contenttypeid;
	private String createdtime;
	private String firstimage;
	private String firstimage2;
	private String cpyrhtDivCd;
	private String mapx;
	private String mapy;
	private String mlevel;
	private String modifiedtime;
	private String sigungucode;
	private String tel;
	private String title;
	private String zipcode;
}

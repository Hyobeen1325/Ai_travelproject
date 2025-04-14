package com.example.demo.dto;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@XmlAccessorType(XmlAccessType.FIELD)
public class CWTravelAPI_01_Item {
	
	// 관광 API에서 받아 LLM에게 전달하고 다시 받을 값들
	@XmlElement(required = false) // 값이 null이면 건너뜀
	private String addr1;
	
	@XmlElement(required = false)
	private String addr2;
	
	@XmlElement(required = false)
	private String areacode;

	@XmlElement(required = false)
	private String booktout;

	@XmlElement(required = false)
	private String cat1;

	@XmlElement(required = false)
	private String cat2;

	@XmlElement(required = false)
	private String cat3;

	@XmlElement(required = false)
	private String contentid;

	@XmlElement(required = false)
	private String contenttypeid;

	@XmlElement(required = false)
	private String createdtime;

	@XmlElement(required = false)
	private String firstimage;

	@XmlElement(required = false)
	private String firstimage2;

	@XmlElement(required = false)
	private String cpyrhtDivCd;

	@XmlElement(required = false)
	private String mapx;

	@XmlElement(required = false)
	private String mapy;

	@XmlElement(required = false)
	private String mlevel;

	@XmlElement(required = false)
	private String modifiedtime;

	@XmlElement(required = false)
	private String sigungucode;

	@XmlElement(required = false)
	private String tel;

	@XmlElement(required = false)
	private String title;

	@XmlElement(required = false)
	private String zipcode;
}

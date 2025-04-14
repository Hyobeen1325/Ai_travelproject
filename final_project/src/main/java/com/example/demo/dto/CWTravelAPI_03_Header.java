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
public class CWTravelAPI_03_Header {
	
	// 참고 구조
	/*
	
{
    "response": {
        "header": {
            "resultCode": "0000",
            "resultMsg": "OK"
        },
        "body": {
            "items": {
                "item": [
                    {
                        "addr1": "강원특별자치도 평창군 평창읍 평창시장2길 14",
                        "addr2": "",
                        "areacode": "32",
                        "booktour": "",
                        "cat1": "A05",
                        "cat2": "A0502",
                        "cat3": "A05020100",
                        "contentid": "2788416",
                        "contenttypeid": "39",
                        "createdtime": "20211208022809",
                        "firstimage": "http://tong.visitkorea.or.kr/cms/resource/85/2788385_image2_1.jpg",
                        "firstimage2": "http://tong.visitkorea.or.kr/cms/resource/85/2788385_image2_1.jpg",
                        "cpyrhtDivCd": "Type3",
                        "mapx": "128.3949124655",
                        "mapy": "37.3664313199",
                        "mlevel": "6",
                        "modifiedtime": "20230701142645",
                        "sigungucode": "15",
                        "tel": "",
                        "title": "가고파부치기",
                        "zipcode": "25376"
                    },...
                ]
            },
            "numOfRows": 10,
            "pageNo": 1,
            "totalCount": 5517
        }
    }
}
	
	 */
	private String resultCode;

	private String resultMsg;
	

}

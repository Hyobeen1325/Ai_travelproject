package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWTravelAPI_04_Response {

	private CWTravelAPI_03_Header header;

	private CWTravelAPI_03_Body body;

}

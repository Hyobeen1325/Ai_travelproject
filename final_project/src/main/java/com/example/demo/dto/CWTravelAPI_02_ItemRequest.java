package com.example.demo.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CWTravelAPI_02_ItemRequest {
	
	private List<CWTravelAPI_01_AreaListRequest> area_list;
			
}

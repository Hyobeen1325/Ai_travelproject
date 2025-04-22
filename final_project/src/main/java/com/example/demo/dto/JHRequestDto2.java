package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class JHRequestDto2 {
    private String message;
    private String email;
    private String high_loc2;
    
    private CWThemeCRUDRequest choose_val;
}

package com.example.demo.dto;

import jakarta.xml.bind.annotation.XmlAccessType;
import jakarta.xml.bind.annotation.XmlAccessorType;
import jakarta.xml.bind.annotation.XmlElement;
import lombok.Data;

@Data
@XmlAccessorType(XmlAccessType.FIELD)
public class Item {
    @XmlElement
    private int rnum;
    @XmlElement
    private String code;
    @XmlElement
    private String name;
}

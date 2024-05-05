package com.example.businessService.dto;

import lombok.*;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class BusinessDTO {
    private String businessName;
    private String type;
    private String description;
}

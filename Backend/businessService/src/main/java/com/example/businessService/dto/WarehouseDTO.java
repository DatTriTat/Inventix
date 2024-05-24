package com.example.businessService.dto;

import java.util.UUID;

import lombok.*;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class WarehouseDTO {
    private UUID id;
    private String name;
    private String address;
    private Double longitude;
    private Double latitude;
}
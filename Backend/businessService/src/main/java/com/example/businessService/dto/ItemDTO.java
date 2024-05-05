package com.example.businessService.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ItemDTO {

    private String name;
    private String category;
    private String description;
    private int quantity;
    private String sku;
    private String stockLevel;
    private String imageUrl;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM-dd-yyyy HH:mm")
    private LocalDateTime expired;
}

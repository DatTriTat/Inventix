package com.example.businessService.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ItemDTO {
    private String name;
    private UUID categoryId;
    private String description = "";
    private double price;
    private String sku;
    private int minStock;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM-dd-yyyy HH:mm")
    private LocalDateTime expired;
    private String imageUrl;
}

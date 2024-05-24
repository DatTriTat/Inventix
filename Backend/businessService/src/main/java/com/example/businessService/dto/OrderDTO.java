package com.example.businessService.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.*;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTO {
    private UUID productId;
    private UUID warehouseId;
    private int stock;
    private String action;
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "MM-dd-yyyy HH:mm")
    private LocalDateTime date;
    private String notes;
    private UUID linkedOrderId;
    private UUID id;

}
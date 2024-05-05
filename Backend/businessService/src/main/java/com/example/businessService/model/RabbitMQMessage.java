package com.example.businessService.model;

import lombok.Data;
import lombok.RequiredArgsConstructor;
 

@Data
@RequiredArgsConstructor
public class RabbitMQMessage {
    private long id;
    private String sku;
    private String location;
    private int quantity;
}

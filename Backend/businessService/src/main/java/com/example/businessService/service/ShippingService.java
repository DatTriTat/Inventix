package com.example.businessService.service;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.businessService.dto.OrderDTO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("shippingService")
public class ShippingService {

    @Autowired
	private RabbitTemplate rabbitTemplate;

    public void sendToQueue1(OrderDTO requestBody) throws JsonProcessingException {
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonMessage = objectMapper.writeValueAsString(requestBody);	
		rabbitTemplate.convertAndSend("direct-exchange", "queue1key", jsonMessage);
	}
}

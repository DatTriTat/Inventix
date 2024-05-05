package com.example.businessService.service;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.businessService.model.RabbitMQMessage;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service("logAndShippingService")
public class LogAndShippingService {

    @Autowired
	private RabbitTemplate rabbitTemplate;

    public void sendToQueue1(RabbitMQMessage data) throws JsonProcessingException {
		ObjectMapper objectMapper = new ObjectMapper();
		String jsonMessage = objectMapper.writeValueAsString(data);	
		rabbitTemplate.convertAndSend("direct-exchange", "queue1key", jsonMessage);
	}
}

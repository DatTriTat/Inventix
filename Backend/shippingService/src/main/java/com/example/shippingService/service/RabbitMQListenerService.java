package com.example.shippingService.service;

import com.example.shippingService.model.Log;
import com.example.shippingService.model.RabbitMQMessage;
import com.example.shippingService.repository.LogRepository;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Optional;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RabbitMQListenerService {

    @Autowired
    private LogRepository logRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @RabbitListener(queues = "queue1")
    public void receiveMessage(String data) {
        try {
            RabbitMQMessage message = objectMapper.readValue(data, RabbitMQMessage.class);
            if(message.getId() == -1) {
                Log newlog = new Log();
                newlog.setSku(message.getSku());
                newlog.setQuantity(message.getQuantity());
                newlog.setLocation(message.getLocation());
                logRepository.save(newlog);
            } else {
                Optional<Log> existLog = logRepository.findById(message.getId());
                existLog.get().setQuantity(message.getQuantity());
                logRepository.save(existLog.get());
            }
        } catch (Exception e) {
            System.err.println("Error processing message: " + e.getMessage());
        }
    }
}

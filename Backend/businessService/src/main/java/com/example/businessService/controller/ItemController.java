package com.example.businessService.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.businessService.dto.ItemDTO;
import com.example.businessService.model.Item;
import com.example.businessService.model.RabbitMQMessage;
import com.example.businessService.service.ItemService;
import com.example.businessService.service.LogAndShippingService;
import com.fasterxml.jackson.core.JsonProcessingException;

@RestController
@RequestMapping("/item")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private LogAndShippingService shippingService;
    
    @PostMapping("/create")
    public void create(@RequestHeader("LoggedInUser") String name, @RequestBody ItemDTO requestBody) {
        itemService.create(requestBody);
        System.out.println("Sucessfully");
    }

    @PostMapping("/edit")
    public void edit(@RequestHeader("LoggedInUser") String name, @RequestBody ItemDTO requestBody) {
        itemService.edit(requestBody);
        System.out.println("Sucessfully");
    }

    @GetMapping("/getAll")
    public List<Item> getAll(@RequestHeader("LoggedInUser") String name) {
        List<Item> items = itemService.getAll();
        return items;
    }
    @GetMapping("/{id}")
    public Item getById(@PathVariable Long id, @RequestHeader("LoggedInUser") String name) {
        return itemService.getById(id);
    }

    @GetMapping("/getExpiredItem")
    public List<Item> getExpiredItem(@RequestHeader("LoggedInUser") String name) {
        return itemService.getItemsExpiringWithinOneWeek();
    }

    @PostMapping("/restock")
    public void shipping(@RequestHeader("LoggedInUser") String name, @RequestBody RabbitMQMessage requestBody) throws JsonProcessingException {
        shippingService.sendToQueue1(requestBody);
        System.out.println("Sucessfully");
    }
}

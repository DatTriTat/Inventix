package com.example.businessService.controller;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.businessService.dto.ItemDTO;
import com.example.businessService.dto.MoveOrderDTO;
import com.example.businessService.dto.OrderDTO;
import com.example.businessService.model.Item;
import com.example.businessService.model.Order;
import com.example.businessService.service.ItemService;
import com.example.businessService.service.OrderService;
import com.fasterxml.jackson.core.JsonProcessingException;

@RestController
@RequestMapping("/item")
public class ItemController {

    @Autowired
    private ItemService itemService;

    @Autowired
    private OrderService orderService;
    
    @PostMapping("/create")
    public List<Item> create( @RequestBody ItemDTO requestBody) {
        return itemService.create(requestBody);
    }

    @PutMapping("/edit/{id}")
    public void editItem(@PathVariable UUID id,  @RequestBody ItemDTO requestBody) {
        itemService.edit(id, requestBody);
    }

    @GetMapping("/all")
    public List<Item> getAll() {
        List<Item> items = itemService.getAll();
        return items;
    }
    @GetMapping("/{id}")
    public Item getById(@PathVariable UUID id ) {
        return itemService.getById(id);
    }

    @GetMapping("/getExpiredItem")
    public List<Item> getExpiredItem() {
        return itemService.getItemsExpiringWithinOneWeek();
    }

    @PostMapping("/order")
    public List<Order> createOrder(  @RequestBody OrderDTO requestBody) throws JsonProcessingException {
        return orderService.create(requestBody);
    }

    @GetMapping("/getAllOrder")
    public List<Order> getAllOrder() {
       return orderService.getAll();
    }

    @DeleteMapping("/{id}")
    public List<Item> deleteItem(@PathVariable UUID id) {
        itemService.deleteItem(id);
        List<Item> items = itemService.getAll();
        return items;
    }

    @PutMapping("/order/{id}")
    public List<Order> editOrder(@PathVariable UUID id,  @RequestBody OrderDTO requestBody) {
        return orderService.edit(id, requestBody);
    }

    @PostMapping("/moveOrder")
    public List<Order> editOrder( @RequestBody MoveOrderDTO requestBody) {
        return orderService.move(requestBody);
    }
}

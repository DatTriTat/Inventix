package com.example.businessService.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.businessService.dto.MoveOrderDTO;
import com.example.businessService.dto.OrderDTO;
import com.example.businessService.model.Order;
import com.example.businessService.repository.OrderRepository;

@Service("OrderService")
public class OrderService {

    @Autowired
    private OrderRepository orderRepository;

    public List<Order> create(OrderDTO order) {
        Order newOrder = new Order();
        newOrder.setAction(order.getAction());
        newOrder.setDate(order.getDate());
        newOrder.setLinkedOrderId(order.getLinkedOrderId());
        newOrder.setNotes(order.getNotes());
        newOrder.setProductId(order.getProductId());
        newOrder.setStock(order.getStock());
        newOrder.setWarehouseId(order.getWarehouseId());
        orderRepository.save(newOrder);
        return orderRepository.findAll();
    }

    public List<Order> getAll() {
        return orderRepository.findAll();
    }

    public List<Order> edit(UUID id,OrderDTO order) {
        Optional<Order> exist = orderRepository.findById(id);
            if(exist.get().getLinkedOrderId() != null) {
                Optional<Order> exist1 = orderRepository.findById(order.getLinkedOrderId());
                exist1.get().setStock(-order.getStock());
                orderRepository.save(exist1.get());
            }
            exist.get().setAction(order.getAction());
            exist.get().setDate(order.getDate());
            exist.get().setLinkedOrderId(order.getLinkedOrderId());
            exist.get().setNotes(order.getNotes());
            exist.get().setProductId(order.getProductId());
            exist.get().setStock(order.getStock());
            exist.get().setWarehouseId(order.getWarehouseId());
            orderRepository.save(exist.get());
        return orderRepository.findAll();
    }

    public List<Order> move(MoveOrderDTO order) {
        Order newOrder = new Order();
        Order newOrder2 = new Order();

        newOrder.setAction(order.getAction());
        newOrder2.setAction(order.getAction());


        newOrder.setDate(order.getDate());
        newOrder2.setDate(order.getDate());

        newOrder.setNotes(order.getNotes());
        newOrder2.setNotes(order.getNotes());

        newOrder.setProductId(order.getProductId());
        newOrder2.setProductId(order.getProductId());

        
        newOrder.setStock(-order.getQuantity());
        newOrder2.setStock(order.getQuantity());

        newOrder.setWarehouseId(order.getFrom());
        newOrder2.setWarehouseId(order.getTo());

        List<Order> savedOrders = orderRepository.saveAll(Arrays.asList(newOrder, newOrder2));

        // Step 2: Retrieve the saved orders with IDs
        Order savedNewOrder = savedOrders.get(0);
        Order savedNewOrder2 = savedOrders.get(1);
        
        // Set linked order IDs
        savedNewOrder.setLinkedOrderId(savedNewOrder2.getId());
        savedNewOrder2.setLinkedOrderId(savedNewOrder.getId());
        
        // Save again with linked IDs
        orderRepository.saveAll(Arrays.asList(savedNewOrder, savedNewOrder2));
        
        // Return the updated list of all orders
        return orderRepository.findAll();
    }
}

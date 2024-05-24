package com.example.businessService.repository;
import org.springframework.data.jpa.repository.JpaRepository;

import com.example.businessService.model.Order;
import java.util.UUID;

public interface OrderRepository extends JpaRepository<Order, UUID> {
}
package com.example.shippingService.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.example.shippingService.model.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {
    Optional<Item> findBySku(String sku);

    @Query("SELECT i FROM Item i WHERE i.expired BETWEEN :start AND :end OR i.expired < :now")
    List<Item> findItemsExpiringWithinOneWeekOrOverExpired(LocalDateTime start, LocalDateTime end, LocalDateTime now);

}

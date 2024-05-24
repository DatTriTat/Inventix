package com.example.businessService.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.example.businessService.model.Item;

public interface ItemRepository extends JpaRepository<Item, UUID> {
    Optional<Item> findByName(String name);


    @Query("SELECT i FROM Item i WHERE i.expired BETWEEN :start AND :end OR i.expired < :now")
    List<Item> findItemsExpiringWithinOneWeekOrOverExpired(LocalDateTime start, LocalDateTime end, LocalDateTime now);

}

package com.example.shippingService.model;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;
 
@Entity
@Table(name = "SHIPPING")
@Data
@RequiredArgsConstructor
public class Shipping {
    
    private @Id @GeneratedValue @JsonIgnore Long id;

    @Column(name = "SKU")
    private String sku;

    @Column(name = "FromLocation")
    private String fromLocation;
    
    @Column(name = "ToLocation")
    private String toLocation;

    @Column(name = "Quantity")
    private int quantity;

    @Column(name = "Status")
    private String status;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}

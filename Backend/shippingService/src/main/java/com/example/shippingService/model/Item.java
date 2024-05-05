package com.example.shippingService.model;

import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Entity
@Table(name = "ITEMS")
@Data
@RequiredArgsConstructor
public class Item {

    private @Id @GeneratedValue @JsonIgnore Long id;

    @NotNull(message = "Name cannot be empty")
    @Column(name = "Name")
    private String name;

    @NotNull(message = "Category cannot be empty")
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "description")
    private String description;

    @Column(name = "expired_Date")
    private LocalDateTime expired;

    @Column(name = "SKU")
    @NotNull(message = "SKU cannot be empty")
    private String sku;

    @Column(name = "stockLevel")
    @NotNull(message = "Min.STOCK LEVEL cannot be empty")
    private String stockLevel;

    @Column(name = "image_URL")
    private String imageUrl;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}

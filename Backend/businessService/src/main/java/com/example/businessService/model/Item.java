package com.example.businessService.model;

import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.UpdateTimestamp;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

@Entity
@Table(name = "ITEMS")
@Data
@RequiredArgsConstructor
public class Item {

    // Use UUID for the primary key
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;

    @NotNull(message = "Name cannot be empty")
    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description", nullable = true)
    private String description = "";

    @NotNull(message = "Category cannot be empty")
    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @NotNull(message = "Price cannot be empty")
    @Column(name = "price", nullable = false)
    private double price;

    @NotNull(message = "SKU cannot be empty")
    @Column(name = "sku", nullable = false)
    private String sku;

    @NotNull(message = "Minimum stock level cannot be empty")
    @Column(name = "min_stock", nullable = false)
    private int minStock;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "expired_date")
    private LocalDateTime expired;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    // Pre-persist method to set UUID if not already assigned
    @PrePersist
    public void prePersist() {
        if (id == null) {
            id = UUID.randomUUID();
        }
    }
}

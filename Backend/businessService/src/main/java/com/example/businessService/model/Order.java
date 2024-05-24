package com.example.businessService.model;

import java.time.LocalDateTime;
import org.hibernate.annotations.GenericGenerator;
import jakarta.persistence.*;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.UUID;

@Entity
@Table(name = "Orders")
@Data
@RequiredArgsConstructor
public class Order {

    // Use UUID for the primary key
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(name = "UUID", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(name = "id", updatable = false, nullable = false)
    private UUID id;
    @Column(name = "productId", nullable = false)
    private UUID productId;
    @Column(name = "warehouseId", nullable = false)
    private UUID warehouseId;
    @Column(name = "stock", nullable = false)
    private int stock;
    @Column(name = "action", nullable = false)
    private String action;
    @Column(name = "date", nullable = false)
    private LocalDateTime date;
    @Column(name = "notes", nullable = false)
    private String notes;
    @Column(name = "linkedOrderId", nullable = true)
    private UUID linkedOrderId;

    // Pre-persist method to set UUID if not already assigned
    @PrePersist
    public void prePersist() {
        if (id == null) {
            id = UUID.randomUUID();
        }
    }
}

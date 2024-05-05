package com.example.businessService.model;

import java.time.LocalDateTime;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Entity
@Table(name = "BUSINESS")
@Data
@RequiredArgsConstructor
public class Business {
    
    private @Id @GeneratedValue @JsonIgnore Long id;

    @NotNull(message = "Business name cannot be empty")
    @Column(name = "business_name")
    private String businessName;

    @Column(name = "type")
    private String type;

    @Column(name = "description")
    private String description;
    
    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}

package com.example.businessService.model;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Entity
@Table(name = "CATEGORY")
@Data
@RequiredArgsConstructor
public class Category {
    
    private @Id @GeneratedValue @JsonIgnore Long id;

    @NotNull(message = "Category cannot be empty")
    @Column(name = "Category")
    private String category;
}

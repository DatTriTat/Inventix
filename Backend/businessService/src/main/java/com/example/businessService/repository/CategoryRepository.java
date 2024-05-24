package com.example.businessService.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.businessService.model.Category;
import java.util.Optional;
import java.util.UUID;

public interface CategoryRepository extends JpaRepository<Category, UUID> {
    Optional<Category> findByName(String name);  
}


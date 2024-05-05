package com.example.businessService.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.businessService.model.Category;
import java.util.Optional;

public interface CategoryRepository extends JpaRepository<Category, Long> {
    Optional<Category> findByCategory(String category);
}


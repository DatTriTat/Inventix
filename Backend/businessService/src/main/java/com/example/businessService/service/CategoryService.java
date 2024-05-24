package com.example.businessService.service;

import java.util.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.businessService.model.Category;
import com.example.businessService.repository.CategoryRepository;

@Service("CategoryService")
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> create(String name, String description) {
        name = name.toUpperCase();
        Optional<Category> existingCategory = categoryRepository.findByName(name);
        if (existingCategory.isEmpty()) {
            Category newCategory = new Category();
            newCategory.setName(name);
            newCategory.setDescription(description);
            categoryRepository.save(newCategory);  // Saves the new category and automatically generates an ID
        }
        return categoryRepository.findAll();  // Returns all categories, including the newly created one
    }
    

    public List<Category> getAll() {
        return categoryRepository.findAll();
    }

}

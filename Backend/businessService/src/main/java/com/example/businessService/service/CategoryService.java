package com.example.businessService.service;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.businessService.model.Category;
import com.example.businessService.repository.CategoryRepository;

@Service("CategoryService")
public class CategoryService {
    @Autowired
    private CategoryRepository categoryRepository;

    public void create(String name) {
        Optional<Category> category = categoryRepository.findByCategory(name);
        if(category.isEmpty()) {
            Category newCategory = new Category();
            name = name.toUpperCase();
            newCategory.setCategory(name);
            categoryRepository.save(newCategory);
        }
    }

}

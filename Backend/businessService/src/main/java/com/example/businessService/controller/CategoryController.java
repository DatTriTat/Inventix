package com.example.businessService.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.example.businessService.model.Category;

import com.example.businessService.service.CategoryService;


@RestController
@RequestMapping("/category") 
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @PostMapping("/create")
    public List<Category> create(@RequestBody Map<String, String> requestBody) {
        
        String category = requestBody.get("name");
        System.out.println(category);
        String description = requestBody.get("description");
        return categoryService.create(category, description);
    }

    @GetMapping("/all")
    public List<Category> getAll() {
        return categoryService.getAll();
    }
}

package com.example.businessService.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.businessService.service.CategoryService;


@RestController
@RequestMapping("/category") 
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @PostMapping("/create")
    public void create(@RequestHeader("LoggedInUser") String name, @RequestBody Map<String, String> requestBody) {
        String category = requestBody.get("category");
        categoryService.create(category);
        System.out.println("Sucessfully");
    }

}

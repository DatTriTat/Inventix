package com.example.businessService.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.businessService.dto.BusinessDTO;
import com.example.businessService.model.Business;
import com.example.businessService.service.BusinessService;



@RestController
@RequestMapping("/business")   
public class BusinessController {
    @Autowired
    private BusinessService service;

    @PostMapping("/create")
    public String CreateBusiness(@RequestHeader("LoggedInUser") String name, @RequestBody BusinessDTO business) {
        service.create(name, business);
        return name + " Created Sucessfully";
    } 

    @GetMapping("/information")
    public Business BusinessInformation(@RequestHeader("LoggedInUser") String name) {
        return service.getBusiness(name);
    } 

    @PostMapping("/edit")
    public String editBusiness(@RequestHeader("LoggedInUser") String name, @RequestBody BusinessDTO business) {
        service.edit(name, business);
        return name + "Edited Sucessfully";
    } 


}

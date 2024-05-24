package com.example.businessService.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.example.businessService.dto.WarehouseDTO;
import com.example.businessService.model.Warehouse;
import com.example.businessService.service.WarehouseService;



@RestController
@RequestMapping("/business")   
public class WarehouseController {
    @Autowired
    private WarehouseService service;

    @PostMapping("/create")
    public List<Warehouse> CreateWarehouse( @RequestBody WarehouseDTO warehouseDTO) {
        return service.createWarehouse(warehouseDTO);
    } 

    @GetMapping("/all")
    public List<Warehouse> BusinessInformation() {
        return service.getAllWarehouses();
    } 

    @PostMapping("/edit")
    public Warehouse editBusiness( @RequestBody WarehouseDTO warehouse) {
        return service.editWarehouse(warehouse.getId(), warehouse);
    } 


}

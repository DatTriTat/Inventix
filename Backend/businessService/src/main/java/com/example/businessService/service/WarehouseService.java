package com.example.businessService.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.businessService.dto.WarehouseDTO;
import com.example.businessService.model.Warehouse;
import com.example.businessService.repository.WarehouseRepository;

@Service("Warehouse")
public class WarehouseService {
    @Autowired
    private WarehouseRepository warehouseRepository;

    // Create a new warehouse
    public List<Warehouse> createWarehouse(WarehouseDTO warehouseDTO) {
        Warehouse newWarehouse = new Warehouse();
        newWarehouse.setName(warehouseDTO.getName());
        newWarehouse.setAddress(warehouseDTO.getAddress());
        warehouseRepository.save(newWarehouse); // Save the new warehouse to the database
        return warehouseRepository.findAll();
    }

    // Retrieve all warehouses
    public List<Warehouse> getAllWarehouses() {
        return warehouseRepository.findAll(); // Assuming a JPA repository that returns all warehouses
    }

    // Update an existing warehouse
    public Warehouse editWarehouse(UUID id, WarehouseDTO warehouseDTO) {
        // Find the warehouse by UUID instead of Long
        Warehouse existingWarehouse = warehouseRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Warehouse not found"));
        
        // Update the existing warehouse's fields with the DTO values
        existingWarehouse.setName(warehouseDTO.getName());
        existingWarehouse.setAddress(warehouseDTO.getAddress());
        
        // Save the updated warehouse entity
        return warehouseRepository.save(existingWarehouse);
    }
}

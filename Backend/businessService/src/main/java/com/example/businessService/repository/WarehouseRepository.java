package com.example.businessService.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.businessService.model.Warehouse;
import java.util.UUID;

public interface WarehouseRepository extends JpaRepository<Warehouse, UUID> {
}
package com.example.shippingService.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.shippingService.model.Log;
import java.util.List;


public interface LogRepository extends JpaRepository<Log, Long> {
    List<Log> findBySkuAndLocation(String sku, String location);

}

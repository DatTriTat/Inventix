package com.example.businessService.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.businessService.model.Business;

public interface BusinessRepository extends JpaRepository<Business, Long> {
}

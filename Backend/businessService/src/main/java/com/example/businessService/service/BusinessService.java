package com.example.businessService.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.businessService.dto.BusinessDTO;
import com.example.businessService.model.Business;
import com.example.businessService.repository.BusinessRepository;

@Service("BusinessService")
public class BusinessService {
    @Autowired
    private BusinessRepository businessRepository;

    public Business create(String ownerName, BusinessDTO business) {
        Business newBusiness = new Business();
        newBusiness.setBusinessName(business.getBusinessName());;
        newBusiness.setType(business.getType());
        newBusiness.setType(business.getDescription());
        businessRepository.save(newBusiness);
        return newBusiness;
    }

    public Business getBusiness(String ownerName) {
        List<Business> business = businessRepository.findAll();
        return business.get(0);
    }

    public Business edit(String ownerName, BusinessDTO business) {
        List<Business> newBusiness = businessRepository.findAll();
        newBusiness.get(0).setBusinessName(business.getBusinessName());;
        newBusiness.get(0).setType(business.getType());
        newBusiness.get(0).setType(business.getDescription());
        businessRepository.save(newBusiness.get(0));
        return newBusiness.get(0);
    }
}

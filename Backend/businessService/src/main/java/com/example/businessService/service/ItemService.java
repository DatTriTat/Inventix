package com.example.businessService.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.businessService.dto.ItemDTO;
import com.example.businessService.model.Category;
import com.example.businessService.model.Item;
import com.example.businessService.repository.CategoryRepository;
import com.example.businessService.repository.ItemRepository;

@Service("ItemService")
public class ItemService {
    private final ItemRepository itemRepository;
    private final CategoryRepository categoryRepository;

    @Autowired
    public ItemService(ItemRepository itemRepository, CategoryRepository categoryRepository) {
        this.itemRepository = itemRepository;
        this.categoryRepository = categoryRepository;
    }

    public Item create(ItemDTO item) {
        Optional<Item> existItem = itemRepository.findBySku(item.getSku());
        if (existItem.isEmpty()) {
            Optional<Category> category = categoryRepository.findByCategory(item.getCategory());
            Item newItem = new Item();
            newItem.setName(item.getName());
            newItem.setCategory(category.get());
            newItem.setDescription(item.getDescription());
            newItem.setExpired(item.getExpired());
            newItem.setSku(item.getSku());
            newItem.setImageUrl(item.getImageUrl());
            newItem.setStockLevel(item.getStockLevel());
            // Save the new item
            return itemRepository.save(newItem);
        }
        return null;
    }

    public Item edit(ItemDTO item) {
        Optional<Item> existItem = itemRepository.findBySku(item.getSku());
        Optional<Category> category = categoryRepository.findByCategory(item.getCategory());
        existItem.get().setName(item.getName());
        existItem.get().setCategory(category.get());
        existItem.get().setDescription(item.getDescription());
        existItem.get().setExpired(item.getExpired());
        existItem.get().setSku(item.getSku());
        existItem.get().setImageUrl(item.getImageUrl());
        existItem.get().setStockLevel(item.getStockLevel());
        itemRepository.save(existItem.get());
        return existItem.get();
    }

    public List<Item> getAll() {
        List<Item> list = itemRepository.findAll();
        return list;
    }

    public Item getById(long id) {
        Optional<Item> item = itemRepository.findById(id);
        return item.get();
    }

    public List<Item> getItemsExpiringWithinOneWeek() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime oneWeekLater = now.plusWeeks(1);
        return itemRepository.findItemsExpiringWithinOneWeekOrOverExpired(now, oneWeekLater, now);
    }

}

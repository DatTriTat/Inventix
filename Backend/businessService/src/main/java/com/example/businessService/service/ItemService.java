package com.example.businessService.service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

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

    public List<Item> create(ItemDTO item) {
        Optional<Item> existItem = itemRepository.findByName(item.getName());
        if (existItem.isEmpty()) {
            Optional<Category> category = categoryRepository.findById(item.getCategoryId());
            Item newItem = new Item();
            newItem.setName(item.getName());
            newItem.setCategory(category.get()); 
            newItem.setDescription(item.getDescription());
            newItem.setSku(item.getSku());
            newItem.setExpired(item.getExpired());
            newItem.setImageUrl(item.getImageUrl());
            newItem.setMinStock(item.getMinStock());
            newItem.setPrice(item.getPrice());
            itemRepository.save(newItem);
            return itemRepository.findAll();
        } else {
            return itemRepository.findAll();
        }
    }

    public void edit(UUID id ,ItemDTO item) {
        Optional<Item> existItem = itemRepository.findById(id);
        Optional<Category> category = categoryRepository.findById(item.getCategoryId());
        existItem.get().setName(item.getName());
        existItem.get().setCategory(category.get()); 
        existItem.get().setDescription(item.getDescription());
        existItem.get().setSku(item.getSku());
        existItem.get().setExpired(item.getExpired());
        existItem.get().setImageUrl(item.getImageUrl());
        existItem.get().setMinStock(item.getMinStock());
        existItem.get().setPrice(item.getPrice());
        itemRepository.save(existItem.get());
    }

    public List<Item> getAll() {
        List<Item> list = itemRepository.findAll();
        return list;
    }

    public Item getById(UUID id) {
        // Find the item by UUID instead of Long
        Optional<Item> item = itemRepository.findById(id);
        // Return the item if it exists, or throw an exception if not found
        return item.orElseThrow(() -> new RuntimeException("Item not found"));
    }

    public List<Item> getItemsExpiringWithinOneWeek() {
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime oneWeekLater = now.plusWeeks(1);
        return itemRepository.findItemsExpiringWithinOneWeekOrOverExpired(now, oneWeekLater, now);
    }

    public void deleteItem(UUID id) {
        if (!itemRepository.existsById(id)) {
            throw new RuntimeException("Item not found!"); // Custom exception handling can be more sophisticated
        }
        itemRepository.deleteById(id); // Perform the deletion
    }

}

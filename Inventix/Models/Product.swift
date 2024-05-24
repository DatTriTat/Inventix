//
//  Product.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import Foundation

struct Product: Identifiable, Equatable, Hashable, Codable {
    var name: String
    var description = ""
    var categoryId: UUID
    var price: Decimal
    var sku: String
    var minStock: Int
    var imageUrl: String
    var expired: Date?
    var createdAt: Date?
    var updatedAt: Date?
    var id: UUID
    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        categoryId: UUID,
        price: Decimal,
        sku: String,
        minStock: Int,
        imageUrl: String,
        expired: Date? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.categoryId = categoryId
        self.price = price
        self.sku = sku
        self.minStock = minStock
        self.imageUrl = imageUrl
        self.expired = expired
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    func daysBeforeExpired() -> Int {
        Calendar.current.dateComponents([.day], from: expired!, to: Date.now).day!
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, sku, minStock, imageUrl, expired, createdAt, updatedAt, category
    }
    
    enum CodingKeys2: String, CodingKey {
        case id, name, description, price, sku, minStock, imageUrl, expired, createdAt, updatedAt, categoryId
    }
    
    
    
    // Nested coding keys for extracting the category id
    enum CategoryKeys: String, CodingKey {
        case id
    }
    
    // Custom initializer to decode from JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode basic properties
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(Decimal.self, forKey: .price)
        self.sku = try container.decode(String.self, forKey: .sku)
        self.minStock = try container.decode(Int.self, forKey: .minStock)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.expired = try container.decode(Date.self, forKey: .expired)
        self.createdAt = try? container.decode(Date.self, forKey: .createdAt)
        self.updatedAt = try? container.decode(Date.self, forKey: .updatedAt)
        
        let categoryContainer = try container.nestedContainer(keyedBy: CategoryKeys.self, forKey: .category)
        self.categoryId = try categoryContainer.decode(UUID.self, forKey: .id)
    }
    
    // Custom encoder to encode to JSON (if needed)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys2.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(sku, forKey: .sku)
        try container.encode(minStock, forKey: .minStock)
        try container.encode(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(expired, forKey: .expired)
        try container.encodeIfPresent(createdAt, forKey: .createdAt)
        try container.encodeIfPresent(updatedAt, forKey: .updatedAt)
        try container.encode(categoryId, forKey: .categoryId)
    }
}

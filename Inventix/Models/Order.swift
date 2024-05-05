//
//  Order.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import Foundation

struct Order: Identifiable {
    var productId: UUID
    var warehouseId: UUID
    var stock: Int
    var action: String
    var date: Date
    var notes: String = ""
    
    var linkedOrderId: UUID?
    
    let id = UUID()
        
    static let example = [
        Order(
            productId: Product.example[0].id,
            warehouseId: Warehouse.example[0].id,
            stock: 600,
            action: "Restock",
            date: Date(),
            notes: "Urgent restock needed for popular items. Sales have been exceeding projections."
        ),
        Order(
            productId: Product.example[0].id,
            warehouseId: Warehouse.example[0].id,
            stock: 1200,
            action: "Restock",
            date: Date(),
            notes: "Urgent restock needed for popular items. Sales have been exceeding projections."
        ),
        Order(
            productId: Product.example[1].id,
            warehouseId: Warehouse.example[0].id,
            stock: 600,
            action: "Restock",
            date: Date()
        ),
        Order(
            productId: Product.example[2].id,
            warehouseId: Warehouse.example[2].id,
            stock: 100,
            action: "Restock",
            date: Date()
        ),
        Order(
            productId: Product.example[0].id,
            warehouseId: Warehouse.example[2].id,
            stock: 800,
            action: "Restock",
            date: Date()
        ),
    ]
}

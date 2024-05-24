//
//  Order.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import Foundation

struct Order: Identifiable, Hashable, Codable {
    var productId: UUID
    var warehouseId: UUID
    var stock: Int
    var action: String
    var date: Date
    var notes: String
    var linkedOrderId: UUID?
    var id: UUID?
    
}

struct MoveOrderRequest: Codable {
    var productId: UUID
    var from: UUID
    var to: UUID
    var action: String
    var date: String
    var notes: String
    var quantity: Int
}

//
//  InventoryViewModel.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import Foundation
import UserNotifications
import SwiftUI

@Observable
class InventoryViewModel {
    private(set) var products: [Product] = Product.example
    private(set) var categories: [Category] = Category.example
    private(set) var warehouses: [Warehouse] = Warehouse.example
    private(set) var orders: [Order] = Order.example
    
    var isScheduled = UserDefaults.standard.bool(forKey: "isScheduled")
    var timeScheduled = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "timeScheduled"))
    
    func sendNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            } else {
                print("Notification sent successfully")
            }
        }
    }
    
    func scheduleNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: timeScheduled)
        dateComponents.minute = Calendar.current.component(.minute, from: timeScheduled)
        
        // show this notification five seconds from now
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            } else {
                print("Notification sent successfully")
            }
        }
    }
    
    func getProduct(id: UUID) -> Product? {
        products.first { $0.id == id }
    }
    
    func addProduct(_ product: Product) {
        products.append(product)
    }
    
    func updateProduct(id: UUID, updatedProduct: Product) {
        products = products.map { $0.id != id ? $0 : updatedProduct }
    }
    
    func getProductFromOrder(_ order: Order) -> Product? {
        products.first { $0.id == order.productId }
    }
    
    func removeProduct(_ product: Product) {
        products.removeAll { $0.id == product.id }
    }
    
    func productsByCategory(_ category: Category) -> [Product] {
        products.filter { $0.categoryId == category.id }
    }
    
    func productsByWarehouse(_ warehouse: Warehouse) -> [Product] {
        var result: [Product] = []
        
        for order in orders {
            if order.warehouseId == warehouse.id, let product = products.first(where: { $0.id == order.productId }) {
                result.append(product)
            }
        }
        
        return result
    }
    
    func filteredProducts(_ products: [Product], searchText: String) -> [Product] {
        guard !searchText.isEmpty else { return products }
        return products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func getQuantity(productId: UUID) -> Int {
        var quantity = 0
        for order in orders {
            if order.productId == productId {
                quantity += order.stock
            }
        }
        
        return quantity
    }
    
    func getWarehouse(id: UUID) -> Warehouse? {
        warehouses.first { $0.id == id }
    }
    
    func getWarehouses(productId: UUID) -> [Warehouse: Int] {
        var result: [Warehouse: Int] = [:]
        
        for order in orders {
            if order.productId == productId, let warehouse = warehouses.first(where: { $0.id == order.warehouseId }) {
                result[warehouse, default: 0] += order.stock
            }
        }
        return result
    }
    
    func getWarehouseOnly(productId: UUID) -> [Warehouse] {
        var result: [Warehouse] = []
        for order in orders {
            if order.productId == productId, let warehouse = warehouses.first(where: { $0.id == order.warehouseId }) {
                if !result.contains(warehouse) {
                    result.append(warehouse)
                }
            }
        }
        return result
    }
    
    func restock(_ order: Order) {
        orders.append(order)
    }
    
    func addProduct(_ order: Order) {
        orders.append(order)
    }
    
    func moveOrder(product: Product, from: Warehouse, to: Warehouse, quantity: Int, date: Date, notes: String) {
        var first = Order(productId: product.id, warehouseId: from.id, stock: -quantity, action: "Moved", date: Date(), notes: notes)
        var second = Order(productId: product.id, warehouseId: to.id, stock: quantity, action: "Moved", date: Date(), notes: notes)
        first.linkedOrderId = second.id
        second.linkedOrderId = first.id
        orders.append(first)
        orders.append(second)
    }
    
    // Update handle logic when delete Moved Order
    func removeOrder(_ order: Order) {
        if order.action == "Moved" {
            orders.removeAll { $0.linkedOrderId == order.id }
            orders.removeAll { $0.id == order.id }
        } else {
            orders.removeAll(where: { $0.id == order.id })
        }
    }
    
    func updateOrder(_ updatedOrder: Order) {
        if updatedOrder.action == "Moved" {
            if var first = orders.first(where: { $0.id == updatedOrder.linkedOrderId }) {
                first.stock = -updatedOrder.stock
                orders = orders.map { $0.id != first.id ? $0 : first }
                orders = orders.map { $0.id != updatedOrder.id ? $0 : updatedOrder }
            }
        } else {
            orders = orders.map { $0.id != updatedOrder.id ? $0 : updatedOrder }
        }
    }
    
    func getOrder(id: UUID) -> Order? {
        orders.first { $0.id == id }
    }
    
    func getOrdersByProduct(_ product: Product) -> [Order] {
        orders.filter { $0.productId == product.id }
    }
    
    func filteredOrders(_ orders: [Order], searchText: String) -> [Order] {
        guard !searchText.isEmpty else { return orders }
        return orders.filter { getProduct(id: $0.productId)!.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func addWarehouse(_ warehouse: Warehouse) {
        warehouses.append(warehouse)
    }
    
    func setWarehouseLocation(longitude: Double, latitude: Double, to warehouse: Warehouse) {
        if let index = warehouses.firstIndex(where: { $0.id == warehouse.id }) {
            warehouses[index].setLocation(longitude: latitude, latitude: longitude)
        }
    }
    
    func filteredWarehouses(_ warehouses: [Warehouse], searchText: String) -> [Warehouse] {
        guard !searchText.isEmpty else { return warehouses }
        return warehouses.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func getCategory(id: UUID) -> Category? {
        categories.first { $0.id == id }
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func filteredOrders(_ categories: [Category], searchText: String) -> [Category] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
}

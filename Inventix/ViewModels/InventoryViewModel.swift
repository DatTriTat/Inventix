//
//  InventoryViewModel.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import Foundation
import UserNotifications
import SwiftUI
import FirebaseStorage

class InventoryViewModel: ObservableObject {
    @Published  var products: [Product] = []
    @Published  var categories: [Category] = []
    @Published var warehouses: [Warehouse] = []
    @Published  var orders: [Order] = []
    @Published var isLoadingProducts = false
    @Published var isLoadingCategories = false
    @Published var isLoadingWarehouses = false
    @Published var isLoadingOrders = false
    var allDataLoaded: Bool {
        !isLoadingProducts && !isLoadingCategories && !isLoadingWarehouses && !isLoadingOrders
    }
    func loadUserData() {
        loadProducts()
        loadCategories()
        loadWarehouses()
        loadOrders()
    }
    
    @Published var isScheduled: Bool {
        didSet {
            UserDefaults.standard.set(isScheduled, forKey: "isScheduled")
            if isScheduled {
                scheduleNotification(title: "Reminder", subtitle: "Don't forget your daily check!")
            }
        }
    }
    @Published var timeScheduled: Date {
        didSet {
            UserDefaults.standard.set(timeScheduled.timeIntervalSince1970, forKey: "timeScheduled")
        }
    }
    
    init() {
        self.isScheduled = UserDefaults.standard.bool(forKey: "isScheduled")
        let timeInterval = UserDefaults.standard.double(forKey: "timeScheduled")
        self.timeScheduled = Date(timeIntervalSince1970: timeInterval)
    }
    
    
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
        guard let url = URL(string: "http://104.199.116.95:80/item/create") else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let encoder = JSONEncoder()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM-dd-yyyy HH:mm"
        encoder.dateEncodingStrategy = .formatted(dateFormatter1)
        do {
            let jsonData = try encoder.encode(product)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self?.products = products
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    
    
    func updateProduct(id: UUID, updatedProduct: Product) {
        guard let url = URL(string: "http://104.199.116.95:80/item/edit/\(id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let encoder = JSONEncoder()
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MM-dd-yyyy HH:mm"
        encoder.dateEncodingStrategy = .formatted(dateFormatter1)
        do {
            let jsonData = try encoder.encode(updatedProduct)
            request.httpBody = jsonData
        } catch {
            print("Error encoding product: \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Network error: \(error!.localizedDescription)")
                return
            }
        }
        .resume()
    }
    
    func getProductFromOrder(_ order: Order) -> Product? {
        return products.first { $0.id == order.productId }
    }
    
    func removeProduct(_ product: Product) {
        guard let url = URL(string: "http://104.199.116.95:80/item/\(product.id)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self?.products = products
                    self?.products.removeAll { $0.id == product.id }
                    
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
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
        guard let url = URL(string: "http://104.199.116.95:80/item/order") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // Set authorization header if token exists
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        // Configure JSON encoder with custom date format
        let encoder = JSONEncoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        encoder.dateEncodingStrategy = .formatted(dateFormatter)
        
        // Encode Order
        do {
            let jsonData = try encoder.encode(order)
            request.httpBody = jsonData
        } catch {
            print("Error encoding order: \(error)")
            return
        }
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("HTTP Error: \(httpResponse.statusCode)")
                return
            }
            print("Order successfully restocked")
        }.resume()
    }
    
    
    
    func moveOrder(product: Product, from: Warehouse, to: Warehouse, quantity: Int, date: Date, notes: String) {
        guard let url = URL(string: "http://104.199.116.95:80/item/moveOrder") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        let moveOrderRequest = MoveOrderRequest(
            productId: product.id,
            from: from.id,
            to: to.id,
            action: "move",
            date: dateString,
            notes: notes,
            quantity: quantity
        )
        do {
            request.httpBody = try JSONEncoder().encode(moveOrderRequest)
        } catch {
            print("Error encoding category: \(error)")
            return
        }
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter2)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return
            }
            do {
                let order = try decoder.decode([Order].self, from: data)
                DispatchQueue.main.async {
                    self?.orders = order
                }
            } catch {
                print("Error decoding JSON response: \(error)")
            }
        }
        .resume()
    }
    
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
            let uuidString = updatedOrder.id!.uuidString
            guard let url = URL(string: "http://104.199.116.95:80/item/order/\(uuidString)") else {
                print("Invalid URL with UUID: \(uuidString)")
                return
            }
            
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let token = SessionManager.shared.currentUserSession?.token {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            // Configure JSON encoder with custom date format
            let encoder = JSONEncoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            encoder.dateEncodingStrategy = .formatted(dateFormatter)
            
            // Encode Order
            do {
                let jsonData = try encoder.encode(updatedOrder)
                request.httpBody = jsonData
            } catch {
                print("Error encoding order: \(error)")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    print("HTTP Error: \(httpResponse.statusCode)")
                    return
                }
                print("Order successfully updated")
            }.resume()
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
    
    func addWarehouse(name: String, address: String) {
        guard let url = URL(string: "http://104.199.116.95:80/business/create") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let warehouseRequest = WarehouseRequest(name: name, address: address, longitude: nil, latitude: nil)
        do {
            let jsonData = try JSONEncoder().encode(warehouseRequest)
            request.httpBody = jsonData
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { [strongSelf = self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let warehouses = try JSONDecoder().decode([Warehouse].self, from: data)
                DispatchQueue.main.async {
                    strongSelf.warehouses = warehouses
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
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
        guard let url = URL(string: "http://104.199.116.95:80/category/create") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let body: [String: String] = [
            "name": category.name,
            "description": category.description ?? ""
        ]
        do {
            request.httpBody = try JSONEncoder().encode(body)
        } catch {
            print("Error encoding category: \(error)")
            return
        }
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return
            }
            do {
                let createdCategories = try JSONDecoder().decode([Category].self, from: data)
                DispatchQueue.main.async {
                    self?.categories = createdCategories
                }
            } catch {
                print("Error decoding JSON response: \(error)")
            }
        }
        .resume()
    }
    
    func filteredOrders(_ categories: [Category], searchText: String) -> [Category] {
        guard !searchText.isEmpty else { return categories }
        return categories.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    func loadWarehouses() {
        guard let url = URL(string: "http://104.199.116.95:80/business/all") else {
            print("Invalid URL")
            return
        }
        self.isLoadingWarehouses = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error or data not received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let warehouses = try JSONDecoder().decode([Warehouse].self, from: data)
                DispatchQueue.main.async {
                    self?.warehouses = warehouses
                    self?.isLoadingWarehouses = false
                    
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func loadCategories() {
        guard let url = URL(string: "http://104.199.116.95:80/category/all") else {
            print("Invalid URL")
            return
        }
        self.isLoadingCategories = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error or data not received: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode([Category].self, from: data)
                DispatchQueue.main.async {
                    self?.categories = categories
                    self?.isLoadingCategories = false
                    
                }
            } catch {
                print("Failed to decode JSON: \(error)")
            }
        }.resume()
        
    }
    
    func loadProducts() {
        guard let url = URL(string: "http://104.199.116.95:80/item/all") else {
            print("Invalid URL")
            return
        }
        self.isLoadingProducts = true
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let products = try decoder.decode([Product].self, from: data)
                DispatchQueue.main.async {
                    self?.products = products
                    self?.isLoadingProducts = false
                    
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
    
    func loadOrders() {
        guard let url = URL(string: "http://104.199.116.95:80/item/getAllOrder") else {
            print("Invalid URL")
            return
        }
        self.isLoadingOrders = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = SessionManager.shared.currentUserSession?.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let orders = try decoder.decode([Order].self, from: data)
                DispatchQueue.main.async {
                    guard let self = self else {
                        print("Self is nil, unable to update orders")
                        return
                    }
                    self.orders = orders
                    self.isLoadingOrders = false
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
        
    }
    
    func uploadImages(_ image: UIImage, completion: @escaping ([String]) -> Void) {
        var urls = [String]()
        let uploadGroup = DispatchGroup()
        uploadGroup.enter()
        let storageRef = Storage.storage().reference().child("inventix_images/\(UUID().uuidString).jpg")
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            storageRef.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("Upload error: \(error.localizedDescription)")
                    uploadGroup.leave()
                    return
                }
                storageRef.downloadURL { url, error in
                    if let url = url {
                        urls.append(url.absoluteString)
                    } else {
                        print("Failed to get download URL: \(error?.localizedDescription ?? "Unknown error")")
                    }
                    uploadGroup.leave()
                }
            }
        } else {
            print("Failed to convert image to JPEG data")
            uploadGroup.leave()
        }
        uploadGroup.notify(queue: .main) {
            completion(urls)
        }
    }
    
}

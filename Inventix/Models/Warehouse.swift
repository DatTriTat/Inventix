//
//  Warehouse.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import Foundation
import MapKit


struct Warehouse: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var address: String
    var longitude: Double?
    var latitude: Double?


    // Custom initializer with a default UUID if none is provided
    init(id: UUID = UUID(), name: String, address: String, longitude: Double? = nil, latitude: Double? = nil, createdAt: Date? = nil, updatedAt: Date? = nil) {
        self.id = id
        self.name = name
        self.address = address
        self.longitude = longitude
        self.latitude = latitude
    }

    // Function to set the location (longitude and latitude)
    mutating func setLocation(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }

   
}

struct WarehouseRequest: Codable {
    var name: String
    var address: String
    var longitude: Double?
    var latitude: Double?

}

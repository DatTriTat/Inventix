//
//  Warehouse.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import Foundation
import MapKit

struct Warehouse: Identifiable, Equatable, Hashable {
    var name: String
    var address: String
    var longitude: Double?
    var latitude: Double?
    let id = UUID()
    
    mutating func setLocation(longitude: Double, latitude: Double) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    static let example: [Warehouse] = [
        .init(name: "Quantum Logistics Hub", address: "1234 Main Street, Dallas, TX 75201"),
        .init(name: "Apex Distribution Center", address: "5678 Industrial Parkway, Chicago, IL 60601"),
        .init(name: "Stellar Storage Solutions", address: "9101 Logistics Boulevard, Atlanta, GA 30301"),
        .init(name: "OmniWare Warehouse", address: "2210 S Highway 40, Unit I, Herber City, UT 84032"),
        .init(name: "Fusion Fulfillment Facility", address: "Warehouse Ln, Walnut Grove, CA 95690")
    ]
    
    static let empty = Warehouse(name: "", address: "")
}

//
//  InventixApp.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import SwiftUI
import UserNotifications

@main
struct InventixApp: App {
    @State private var productStore = InventoryViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView().environment(productStore)
        }
    }
}

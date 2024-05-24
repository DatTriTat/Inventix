//
//  InventixApp.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import SwiftUI
import UserNotifications

import Firebase

@main
struct InventixApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var productStore = InventoryViewModel()
    @StateObject private var sessionManager = SessionManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView(sessionManager: sessionManager, productStore: productStore)
                .environmentObject(productStore)
                .environmentObject(sessionManager)
        }
    }
}

struct ContentView: View {
    @ObservedObject var sessionManager: SessionManager
    @StateObject var productStore: InventoryViewModel

    var body: some View {
        if sessionManager.getAuthToken() != nil, productStore.allDataLoaded {
            HomeView()
                .environmentObject(productStore)
                .environmentObject(sessionManager)
        } else {
            LoginView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: productStore))
        }
    }
}



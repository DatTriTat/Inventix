//
//  HomeView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct HomeView: View {
    @State private var store = InventoryViewModel()
    @State private var selectedMenuItem: Menu? = Menu.products
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var showAddProduct = false
    @State private var showRestock = false
    @State private var isChatVisible = false

    init() {
        UITabBar.appearance().backgroundColor = UIColor.tabview
    }
    
    var body: some View {
        ZStack {
            if UIDevice.current.userInterfaceIdiom == .phone {
                iphoneNavigationView
            } else if UIDevice.current.userInterfaceIdiom == .pad {
                ipadNavigationView
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("Permission approved!")
                    scheduleNotification()
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        .onChange(of: store.timeScheduled) {
            scheduleNotification()
        }
        .onChange(of: store.isScheduled) {
            scheduleNotification()
        }
        .overlay(
                Button(action: {
                    isChatVisible = true
                }) {
                    Image(systemName: "message.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 80),
                alignment: .bottomTrailing
            )
        .sheet(isPresented: $isChatVisible) {
            ChatView(store: InventoryViewModel(), openAIManager: OpenAIManager(store: InventoryViewModel()))
        }
    }
    
    private var iphoneNavigationView: some View {
        TabView(selection: $selectedMenuItem) {
            NavigationStack {
                ProductListView()
                    .environmentObject(InventoryViewModel())
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            NavigationLink {
                                ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
                                    .environmentObject(InventoryViewModel())
                                    .navigationTitle("Profile")
                            } label: {
                                profile
                            }
                        }
                    }
                    .background(Color.background)
            }
            .tabItem { Label("Products", systemImage: "book") }
            .tag(Menu.products as Menu?)

            NavigationStack {
                OrderListView(orders: store.orders)
                    .environmentObject(InventoryViewModel())
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            NavigationLink {
                                ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
                                    .environmentObject(InventoryViewModel())
                                    .navigationTitle("Profile")
                            } label: {
                                profile
                            }
                        }
                    }
                    .background(Color.background)
            }
            .tabItem { Label("Orders", systemImage: "cube.box") }
            .tag(Menu.orders as Menu?)
            
            NavigationStack {
                ScannerView()
                    .environmentObject(InventoryViewModel())
                    .background(Color.background)
            }
            .tabItem { Label("Scan", systemImage: "qrcode.viewfinder") }
            .tag(Menu.scanner as Menu?)
            
            NavigationStack {
                WarehouseListView()
                    .environmentObject(InventoryViewModel())
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            NavigationLink {
                                ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
                                    .environmentObject(InventoryViewModel())
                                    .navigationTitle("Profile")
                            } label: {
                                profile
                            }
                        }
                    }
                    .background(Color.background)
            }
            .tabItem { Label("Warehouses", systemImage: "mappin.and.ellipse") }
            .tag(Menu.warehouses as Menu?)
            
            NavigationStack {
                CategoryListView()
                    .environmentObject(NavigationController())
                    .environmentObject(InventoryViewModel())
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            NavigationLink {
                                ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
                                    .environmentObject(InventoryViewModel())
                                    .navigationTitle("Profile")
                            } label: {
                                profile
                            }
                        }
                    }
                    .background(Color.background)
            }
            .tabItem { Label("Categories", systemImage: "square.grid.2x2") }
            .tag(Menu.categories as Menu?)
            
        }
    }
    
    private var profile: some View {
        AsyncImage(url: URL(string: "https://res.cloudinary.com/glide/image/fetch/t_media_lib_thumb/https%3A%2F%2Fstorage.googleapis.com%2Fglide-prod.appspot.com%2Fuploads-v2%2FYGvI36VoQe5mJNelMBS1-template-builder%2Fpub%2F8ijk5Xchy5qkOz4fHEy6.png")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
        }
    }
    
    @ViewBuilder
    private var ipadNavigationView: some View {
        NavigationSplitView {
            List(Menu.allCases, selection: $selectedMenuItem) { menuItem in
                Label(menuItem.rawValue.capitalized, systemImage: menuItem.icon)
                    .tag(menuItem)
            }
            .navigationTitle("Inventix")
            .background(Color.background)
        } detail: {
            switch selectedMenuItem {
            case .products:
                ProductListView()
                    .environmentObject(InventoryViewModel())
            case .orders:
                OrderListView(orders: store.orders)
                    .environmentObject(InventoryViewModel())
            case .scanner:
                ScannerView()
                    .environmentObject(InventoryViewModel())
            case .warehouses:
                WarehouseListView()
                    .environmentObject(InventoryViewModel())
            case .categories:
                CategoryListView()
                    .environmentObject(InventoryViewModel())
                    .environmentObject(NavigationController())
            case .profile:
                ProfileView(authenticationViewModel: AuthenticationViewModel(inventoryViewModel: InventoryViewModel()))
                    .environmentObject(InventoryViewModel())
            default:
                Text("Select a menu")
                    .background(Color.background)
            }
        }
        
    }
    
    func scheduleNotification() {
        if store.isScheduled {
            let expiredProducts = store.products.filter({ $0.daysBeforeExpired() < 2 })
            if !expiredProducts.isEmpty {
                store.scheduleNotification(title: "Expired Soon!", subtitle: "Please checkout your products")
            }
        }
    }
    
    enum Menu: String, CaseIterable, Identifiable {
        case products, orders, scanner, warehouses, categories, profile
        var icon: String {
            switch self {
            case .products:
                "book"
            case .orders:
                "cube.box"
            case .scanner:
                "qrcode.viewfinder"
            case .warehouses:
                "mappin.and.ellipse"
            case .categories:
                "square.grid.2x2"
            case .profile:
                "person.crop.circle"
            }
        }
        var id: String { self.rawValue }
    }
}

extension String: Identifiable {
    public var id: String { self }
}

#Preview {
    HomeView()
}

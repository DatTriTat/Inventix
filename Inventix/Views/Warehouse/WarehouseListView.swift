//
//  WarehouseListView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI
import MapKit

struct WarehouseListView: View {
    @Environment(InventoryViewModel.self) private var store

    @State private var searchTextWarehouse = ""
    @State private var searchTextProduct = ""
    @State private var showAddWarehouse = false
    @State private var showEditWarehouse = false
    @State private var showAddProduct = false
    
    var body: some View {
        List {
            Section {
                Map() {
                    ForEach(store.warehouses) { warehouse in
                        if let latitude = warehouse.latitude, let longitude = warehouse.longitude {
                            Marker(warehouse.name,
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            )
                        }
                    }
                }
                .frame(
                    height: UIDevice.current.userInterfaceIdiom == .phone ? 300 : 450
                )
            }
            .listRowBackground(Color.background)
            
            ForEach(store.filteredWarehouses(store.warehouses, searchText: searchTextWarehouse)) { warehouse in
                let products = Array(Set(store.productsByWarehouse(warehouse)))

                NavigationLink {
                    if !products.isEmpty {
                        List(store.filteredProducts(products, searchText: searchTextProduct)) { product in
                            NavigationLink {
                                ProductDetailView(product: product, isWarehouseView: true)
                                    .environment(store)
                            } label: {
                                HStack(alignment: .top) {
                                    AsyncImage(url: URL(string: product.imageUrl)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .scaledToFit()
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(product.name)
                                            .fontWeight(.semibold)
                                        Text("\(store.getQuantity(productId: product.id)) units")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .listRowBackground(Color.background)
                            }
                            .listRowBackground(Color.background)
                        }
                        .background(Color.background)
                        .listStyle(.plain)
                        .navigationTitle(warehouse.name)
                        .searchable(text: $searchTextProduct)
                    } else {
                        Text("No Products Available")
                    }
                } label: {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text(warehouse.name)
                                .fontWeight(.semibold)
                            Text(warehouse.address)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button {
                            showEditWarehouse.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .imageScale(.large)
                                .foregroundStyle(Color.accentColor)
                        }
                    }
                }
                .sheet(isPresented: $showEditWarehouse) {
                    NavigationStack {
                        EditWarehouseView(warehouse: warehouse)
                            .environment(store)
                    }
                }
            }
            .listRowBackground(Color.background)
        }
        .background(Color.background)
        .listStyle(.plain)
        .sheet(isPresented: $showAddWarehouse) {
            NavigationStack {
                AddWarehouseView()
                    .environment(store)
            }
        }
        .sheet(isPresented: $showAddProduct) {
            NavigationStack {
                AddProductView()
                    .environment(store)
            }
        }
        .scrollIndicators(.hidden)
        .searchable(text: $searchTextWarehouse)
        .navigationTitle("Warehouses")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddWarehouse.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .onAppear {
            for warehouse in store.warehouses {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(warehouse.address) { placemarks, error in
                    guard let placemark = placemarks?.first, let location = placemark.location else {
                        print("Error geocoding address:", error ?? "Unknown error")
                        return
                    }
                    store.setWarehouseLocation(
                        longitude: location.coordinate.latitude,
                        latitude: location.coordinate.longitude,
                        to: warehouse
                    )
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WarehouseListView()
            .environment(InventoryViewModel())
    }
}

//
//  SaleView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/12/24.
//

import SwiftUI

struct SaleView: View {
    @StateObject private var store = InventoryViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var product: Product
    @State private var quantity = 0
    @State private var date = Date()
    @State private var selectedWarehouse: Warehouse?
    @State private var notes = ""

    var body: some View {
        Form {
            Section("Name") {
                Text(product.name)
            }
            
            Section {
                DatePicker("Start Date", selection: $date, displayedComponents: [.date])
            } header: {
                HStack {
                    Spacer()
                    Text("Required")
                }
            }
            
            Section("Warehouses") {
                Picker("Warehouses", selection: $selectedWarehouse) {
                    Text("Select").tag(Optional<Warehouse>(nil))
                    ForEach(store.getWarehouseOnly(productId: product.id)) { warehouse in
                        Text(warehouse.name).tag(warehouse as Warehouse?)
                    }
                }
                .pickerStyle(.navigationLink)
            }
            
            Section {
                TextField("Units", value: $quantity, format: .number)
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Quantity")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(height: 150)
            }
        }
        .navigationTitle("Sale")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .foregroundStyle(.red)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    if let selectedWarehouse {
                        store.restock(Order(productId: product.id, warehouseId: selectedWarehouse.id, stock: -quantity, action: "Sale", date: date, notes: notes))
                        
                        let quantity = store.getQuantity(productId: product.id)
                        if quantity == 0 {
                            store.sendNotification(title: "Out of Stock", subtitle: "\(product.name) is out of stock. Restock soon")
                        } else if quantity <= product.minStock {
                            store.sendNotification(title: "Low Stock", subtitle: "\(product.name) is about out of stock. Restock soon")
                        }
                        dismiss()
                    }
                }
                .disabled(quantity <= 0 || selectedWarehouse == nil)
            }
        }
        .onAppear(){
            store.loadUserData()
        }
    }
}


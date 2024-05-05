//
//  RestockView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import SwiftUI

struct RestockView: View {
    @Environment(InventoryViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State var product: Product
    @State private var quantity = 0
    @State private var date = Date()
    @State private var selectedWarehouse: Warehouse?
    @State private var notes = ""

    var body: some View {
        NavigationStack {
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
                        ForEach(store.warehouses) { warehouse in
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
            .navigationTitle("Restock")
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
                            store.restock(
                                Order(productId: product.id, warehouseId: selectedWarehouse.id, stock: quantity, action: "Restock", date: date)
                            )
                            dismiss()
                        }
                    }
                    .disabled(quantity <= 0 || selectedWarehouse == nil)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
        }
    }
}

#Preview {
    NavigationStack {
        RestockView(product: Product.example[0])
            .environment(InventoryViewModel())
    }
}

//
//  MoveProductView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/5/24.
//

import SwiftUI

struct MoveProductView: View {
    @Environment(InventoryViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Binding var product: Product
    @State private var quantity = 0
    @State private var fromWarehouse: Warehouse?
    @State private var toWarehouse: Warehouse?
    @State private var notes: String = ""
    @State private var date = Date()

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
            
            Section {
                Picker("From", selection: $fromWarehouse) {
                    Text("Select").tag(Optional<Warehouse>(nil))
                    ForEach(store.getWarehouseOnly(productId: product.id)) { warehouse in
                        Text(warehouse.name).tag(warehouse as Warehouse?)
                    }
                }
                .pickerStyle(.navigationLink)
                
                Picker("To", selection: $toWarehouse) {
                    Text("Select").tag(Optional<Warehouse>(nil))
                    ForEach(store.warehouses) { warehouse in
                        if let fromWarehouse, warehouse.id != fromWarehouse.id {
                            Text(warehouse.name).tag(warehouse as Warehouse?)
                        }
                    }
                }
                .pickerStyle(.navigationLink)
            } header: {
                HStack {
                    Text("Warehouse")
                    Spacer()
                    Text("Required")
                }
            }
            
            
            Section(header: Text("Notes")) {
                TextEditor(text: $notes)
                    .frame(height: 150)
            }
        }
        .navigationTitle("Move Product")
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
                    store.moveOrder(product: product, from: fromWarehouse!, to: toWarehouse!, quantity: quantity, date: date, notes: notes)
                    dismiss()
                }
                .disabled(
                    quantity == 0 ||
                    fromWarehouse == nil ||
                    toWarehouse == nil ||
                    quantity > store.getQuantity(productId: product.id)
                )
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        MoveProductView(product: .constant(Product.example[0]))
            .environment(InventoryViewModel())
    }
}

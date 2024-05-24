//
//  EditOrderView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import SwiftUI

struct EditOrderView: View {
    @StateObject private var store = InventoryViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var order: Order
    @State var product: Product
    var body: some View {
        let maxQuantity = store.getQuantity(productId: product.id)
        
        Form {
            Section("Name") {
                Text(product.name)
            }
            
            Section {
                DatePicker(
                    "Start Date",
                    selection: $order.date,
                    displayedComponents: [.date]
                )
            } header: {
                HStack {
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextField("Units", value: $order.stock, format: .number)
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Quantity")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $order.notes)
                    .frame(height: 150)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .foregroundStyle(.red)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    store.updateOrder(order)
                    dismiss()
                }
                .disabled(order.stock > maxQuantity)
            }
        }
        .onAppear(){
            store.loadUserData()
        }
    }
}


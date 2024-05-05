//
//  EditOrderView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import SwiftUI

struct EditOrderView: View {
    @Environment(InventoryViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @Binding var order: Order
    
    var body: some View {
        let product = store.getProductFromOrder(order)!
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
        .scrollContentBackground(.hidden)
        .background(Color.background)
    }
}

#Preview {
    NavigationStack {
        EditOrderView(order: .constant(Order.example[0]))
            .environment(InventoryViewModel())
    }
}

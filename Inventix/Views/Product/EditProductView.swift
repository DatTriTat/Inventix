//
//  EditProductView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/1/24.
//

import SwiftUI

struct EditProductView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) private var presentationMode
    @Environment(InventoryViewModel.self) private var store
    @Binding var product: Product
    
    var body: some View {
        Form {
            Section {
                TextField("", text: $product.name)
            } header: {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section(header: Text("Description")) {
                TextEditor(text: $product.description)
                    .frame(height: 150)
            }

            Section {
                Picker("Category", selection: $product.categoryId) {
                    ForEach(store.categories) { category in
                        Text(category.name).tag(category.id)
                    }
                }
                .pickerStyle(.navigationLink)
            } header: {
                HStack {
                    Text("Category")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextField("", value: $product.price, format: .currency(code: "USD"))
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Price")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextField("", text: $product.sku)
            } header: {
                HStack {
                    Text("SKU")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextField("", value: $product.minStock, format: .number)
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Min. Stock Level")
                    Spacer()
                    Text("Required")
                }
            }
        }
        .navigationTitle("Edit Product")
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
                    store.updateProduct(id: product.id, updatedProduct: product)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditProductView(product: .constant(Product.example[0]))
        .environment(InventoryViewModel())
}

//
//  AddWarehouseView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI

struct AddWarehouseView: View {
    @StateObject private var store = InventoryViewModel()
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var address = ""
    
    var body: some View {
        Form {
            Section {
                TextField("", text: $name)
            } header: {
                HStack {
                    Text("Name")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextEditor(text: $address)
                    .frame(height: 100)
            } header: {
                HStack {
                    Text("Address")
                    Spacer()
                    Text("Required")
                }
            }
        }
        .navigationTitle("Add Warehouse")
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
                    store.addWarehouse(name: name, address: address)
                    dismiss()
                }
                .disabled(name.isEmpty && address.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddWarehouseView()
            .environmentObject(InventoryViewModel())
    }
}

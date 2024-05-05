//
//  EditWarehouseView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI

struct EditWarehouseView: View {
    @Environment(\.dismiss) private var dismiss
    var warehouse: Warehouse
    @State private var name: String
    
    init(warehouse: Warehouse) {
        self.warehouse = warehouse
        self.name = self.warehouse.name
    }
    
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
        }
        .navigationTitle("Edit Warehouse")
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
                    dismiss()
                    print(warehouse.name)
                    print(name)
                }
                .disabled(name == warehouse.name)
            }
        }
    }
}

#Preview {
    EditWarehouseView(warehouse: Warehouse.example[0])
}

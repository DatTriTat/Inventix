//
//  AddCategoryView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(InventoryViewModel.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    
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
            
            Section(header: Text("Description")) {
                TextEditor(text: $description)
                    .frame(height: 150)
            }
        }
        .navigationTitle("Add Category")
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
                    store.addCategory(Category(name: name, description: description))
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddCategoryView()
            .environment(InventoryViewModel())
    }
}

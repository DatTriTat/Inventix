//
//  AddProductView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: InventoryViewModel
    
    @State private var name = ""
    @State private var description = ""
    @State private var selectedCategory: Category? = nil
    @State private var price = 0
    @State var sku = ""
    @State private var minStock = 0
    @State private var expired = Date()
    @State private var showAddCategory = false
    @State private var data: Data?
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var url: URL?
    
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
            
            Section {
                Picker("Category", selection: $selectedCategory) {
                    Text("Select").tag(nil as Category?)
                    ForEach(store.categories) { category in
                        Text(category.name).tag(category as Category?)
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
                TextField("", value: $price, formatter: currencyFormatter)
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Price")
                    Spacer()
                }
            }
            
            Section {
                TextField("", text: $sku)
            } header: {
                HStack {
                    Text("SKU")
                    Spacer()
                    Text("Required")
                }
            }
            
            Section {
                TextField("", value: $minStock, format: .number)
                    .keyboardType(.numberPad)
            } header: {
                HStack {
                    Text("Min. Stock Level")
                    Spacer()
                    Text("Required")
                }
            }
            
            DatePicker("Expired", selection: $expired, displayedComponents: .date)
            
            Section {
                PhotosPicker(
                    selection: $selectedItems,
                    maxSelectionCount: 1,
                    matching: .images
                ) {
                    HStack {
                        if let data = data, let uiimage = UIImage(data: data) {
                            Image(uiImage: uiimage)
                                .resizable()
                                .scaledToFit()
                                .symbolRenderingMode(.multicolor)
                        } else {
                            Image(systemName: "photo")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 20))
                            Text("Choose a photo")
                        }
                    }
                    .foregroundColor(.secondary)
                }
                .onChange(of: selectedItems) {
                    guard let item = selectedItems.first else { return }
                    item.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                self.data = data
                            } else {
                                print("Data is nil")
                            }
                        case .failure(let failure):
                            fatalError("\(failure)")
                        }
                    }
                }
            } header: {
                HStack {
                    Text("Photo")
                    Spacer()
                    Text("Required")
                }
            }
        }
        .navigationTitle("Add Product")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            store.loadUserData()
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
                    if let selectedCategory, let data = data, let uiImage = UIImage(data: data) {
                        print(uiImage)
                        store.uploadImages(uiImage) { urls in
                            if let url = urls.first { 
                                let newProduct = Product(
                                    name: name,
                                    description: description,
                                    categoryId: selectedCategory.id,
                                    price: Decimal(price),
                                    sku: sku,
                                    minStock: minStock,
                                    imageUrl: url,
                                    expired: expired
                                )
                                store.addProduct(newProduct)
                                dismiss()
                            } else {
                                print("Failed to upload image or retrieve URL")
                            }
                        }
                    }
                }
                .disabled(name.isEmpty || selectedCategory == nil || price <= 0 || sku.isEmpty || minStock <= 0)

            }
        }
        .sheet(isPresented: $showAddCategory) {
            NavigationStack {
                AddCategoryView()
                    .environmentObject(InventoryViewModel())
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    private var currencyFormatter: NumberFormatter {
           let formatter = NumberFormatter()
           formatter.numberStyle = .currency
           formatter.currencyCode = "USD"
           formatter.currencySymbol = "$"
           formatter.locale = Locale(identifier: "en_US")  // Ensures $ is before and uses comma for thousands separator
           return formatter
       }
}

#Preview {
    NavigationStack {
        AddProductView()
            .environmentObject(InventoryViewModel())
    }
}

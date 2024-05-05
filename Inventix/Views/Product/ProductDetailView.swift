//
//  ProductDetailView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/30/24.
//

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InventoryViewModel.self) private var store
    @State var product: Product
    @State private var showProductEditor = false
    @State private var deleteConfirm = false
    @State private var showRestock = false
    @State private var showMove = false
    @State private var showSale = false
    var isWarehouseView = false
    
    var body: some View {
        Form {
            Section("Product Information") {
                productInfo.listRowSeparator(.visible)
            }
            .listRowBackground(Color.customSection)
            
            Section("Invetory Information") {
                inventoryInfo
            }
            .listRowBackground(Color.customSection)
            
            let result = store.getWarehouses(productId: product.id).sorted(by: { $0.key.name < $1.key.name } )
            if !result.isEmpty {
                Section("Warehouses") {
                    List(result, id: \.key) { warehouse, stock in
                        LabeledContent(warehouse.name) {
                            Text("\(stock)")
                            Text("units")
                        }
                    }
                }
                .listRowBackground(Color.customSection)
            }
            
            Section("Barcode") {
                QRCodeView(text: product.sku)
            }
            .listRowBackground(Color.customSection)

            
            let orders = store.orders.filter { $0.productId == product.id }
            if !orders.isEmpty {
                Section("History") {
                    List(orders) { order in
                        if let product = store.getProductFromOrder(order) {
                            NavigationLink {
                                OrderDetailView(order: order)
                                    .environment(store)
                                    .navigationTitle("Order Details")
                            } label: {
                                let isAdded = order.stock > 0
                                HStack(alignment: .bottom) {
                                    VStack(alignment: .leading) {
                                        Text(product.sku).fontWeight(.semibold)
                                        Text("\(isAdded ? "+" : "")\(order.stock) (\(order.action))").font(.subheadline).foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(order.date, style: .date)
                                        .foregroundStyle(.secondary)
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .listRowBackground(Color.customSection)
            }
        }
        .sheet(isPresented: $showProductEditor) {
            NavigationStack {
                EditProductView(product: $product)
            }
        }
        .sheet(isPresented: $showRestock) {
            NavigationStack {
                RestockView(product: product)
            }
        }
        .sheet(isPresented: $showMove) {
            NavigationStack {
                MoveProductView(product: $product)
            }
        }
        .sheet(isPresented: $showSale) {
            NavigationStack {
                SaleView(product: $product)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    actions
                } label: {
                    Label("Actions", systemImage: "ellipsis.circle")
                }
            }
            
        }
        .onChange(of: product) {
            print("yes")
        }
        .scrollContentBackground(.hidden)
        .background(Color.background)
    }
    
    private var productInfo: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(product.sku)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var actions: some View {
        VStack {
            Button {
                showProductEditor.toggle()
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            Button {
                showRestock.toggle()
            } label: {
                Label("Restock", systemImage: "arrow.circlepath")
            }
            
            Button {
                showSale.toggle()
            } label: {
                Label("Sale", systemImage: "dollarsign")
            }
            
            Button {
                showMove.toggle()
            } label: {
                Label("Move", systemImage: "shippingbox.and.arrow.backward.fill")
            }
            
            if !isWarehouseView {
                Button(role: .destructive) {
                    deleteConfirm.toggle()
                } label: {
                    Label("Delete", systemImage: "trash")
                        .labelStyle(.titleAndIcon)
                        .frame(maxWidth: .infinity)
                }
                .confirmationDialog("Are you sure to delete?", isPresented: $deleteConfirm) {
                    Button("Delete", role: .destructive) {
                        store.removeProduct(product)
                        dismiss()
                    }
                    Button("Cancel", role: .cancel) {
                        deleteConfirm = false
                    }
                } message: {
                    Text("Are you sure to delete this product?")
                }
            }
        }
    }
    
    @ViewBuilder
    private var inventoryInfo: some View {
        let quantity = store.getQuantity(productId: product.id)
        let indicatorColor = if quantity <= 0 {
            Color.red
        } else if quantity <= product.minStock {
            Color.orange
        } else {
            Color.secondary
        }
                                         
        Group {
            LabeledContent("Current Inventory") {
                Text("\(quantity)")
                    .foregroundStyle(indicatorColor)
                Text("units")
            }
            
            LabeledContent("Min. Stock Level") {
                Text("\(product.minStock)")
                Text("units")
            }
            
            if let category = store.getCategory(id: product.categoryId) {
                LabeledContent("Category") {
                    Text("\(category.name)")
                }
            }
            
            LabeledContent("Price") {
                Text(product.price, format: .currency(code: "USD"))
            }
            
            LabeledContent("Expired Date") {
                Text(product.expired, style: .date)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.example[0])
            .environment(InventoryViewModel())
    }
}

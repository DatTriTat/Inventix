//
//  OrderDetailView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var store = InventoryViewModel()
    @State private var showEditOrder = false
    @State var order: Order
    @State private var deleteConfirm = false
    @State var product: Product

    var body: some View {
        
        NavigationStack {
            Form {                
                Section {
                    productInfo
                }
                .listRowBackground(Color.customSection)
                            
                Section("Inventory Information") {
                    inventoryInfo
                }
                .listRowBackground(Color.customSection)
                
                if !order.notes.isEmpty {
                    Section("Notes") {
                        Text(order.notes)
                    }
                    .listRowBackground(Color.customSection)
                }
                
                Section("Barcode") {
                    QRCodeView(text: product.sku)
                }
                .listRowBackground(Color.customSection)
            }
            .onAppear() {
                store.loadUserData()
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditOrder) {
                NavigationStack {
                    EditOrderView(order: $order, product: product)
                        .navigationTitle("Edit Order")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEditOrder.toggle()
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.background)
    
        }
    }
    
    @ViewBuilder
    private var productInfo: some View {        
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(store.getCategory(id: product.categoryId)?.name ?? "Unknown")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private var inventoryInfo: some View {
        Group {
            LabeledContent(order.action) {
                Text(order.date, style: .date)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            LabeledContent("Quantity") {
                Text("\(order.stock) units")
            }
            
            if let warehouse = store.getWarehouse(id: order.warehouseId) {
                LabeledContent("Warehouse") {
                    Text(warehouse.name)
                }
            }
        }
    }
 
}


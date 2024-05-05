//
//  OrderDetailView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/3/24.
//

import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(InventoryViewModel.self) private var store
    @State private var showEditOrder = false
    @State var order: Order
    @State private var deleteConfirm = false
    
    var body: some View {
        let product = store.getProductFromOrder(order)!
        
        NavigationStack {
            Form {                
                Section {
                    productInfo
                }
                            
                Section("Inventory Information") {
                    inventoryInfo
                }
                
                if !order.notes.isEmpty {
                    Section("Notes") {
                        Text(order.notes)
                    }
                }
                
                Section("Barcode") {
                    QRCodeView(text: product.sku)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditOrder) {
                NavigationStack {
                    EditOrderView(order: $order)
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
        let product = store.getProductFromOrder(order)!
        
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

#Preview {
    OrderDetailView(order: Order.example[0])
        .environment(InventoryViewModel())
}

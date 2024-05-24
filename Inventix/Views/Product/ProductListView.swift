//
//  ProductListView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/28/24.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject private var store: InventoryViewModel 
    @State private var searchText = ""
    @State private var showAddProduct = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                ForEach(store.categories) { category in
                    let products = store.filteredProducts(store.productsByCategory(category), searchText: searchText)
                    
                    VStack {
                        HStack {
                            if !products.isEmpty {
                                Text(category.name)
                                    .font(.title2)
                                Spacer()
                                NavigationLink {
                                    VerticalProductListView(products: products)
                                        .navigationTitle(category.name)
                                        .environmentObject(InventoryViewModel())
                                        .environmentObject(NavigationController())

                                } label: {
                                    HStack(alignment: .center) {
                                        Text("See All")
                                        Image(systemName: "chevron.right")
                                            .imageScale(.small)
                                    }
                                }
                            }
                        }
                        .fontWeight(.semibold)
                        .searchable(text: $searchText)
                        
                        NavigationStack {
                            ScrollView(.horizontal) {
                                HStack(alignment: .firstTextBaseline) {
                                    ForEach(products) { product in
                                        NavigationLink {
                                            ProductDetailView(product: product)
                                                .environmentObject(InventoryViewModel())
                                                .environmentObject(NavigationController())
                                        } label: {
                                            VStack(alignment: .leading) {
                                                AsyncImage(url: URL(string: product.imageUrl)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                .frame(height: 110)
                                                
                                                Text(product.name)
                                                    .fontWeight(.semibold)
                                                HStack(spacing: 6) {
                                                    Text("\(store.getQuantity(productId: product.id))")
                                                    Text("units")
                                                }
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                            }
                                            .frame(width: 140, height: 170)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                        }
                    }
                }
                //.padding()
                //.background(RoundedRectangle(cornerRadius: 8).fill(Color.customSection))

            }
        }
        .padding()
        .sheet(isPresented: $showAddProduct) {
            NavigationStack {
                AddProductView()
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Products")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddProduct.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .background(Color.background)
        .onAppear(){
            store.loadUserData()
        }
    }
}

#Preview {
    NavigationStack {
        ProductListView()
            .environmentObject(InventoryViewModel())
    }
}

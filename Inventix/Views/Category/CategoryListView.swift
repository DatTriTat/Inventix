//
//  CategoryListView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/29/24.
//

import SwiftUI

struct CategoryListView: View {
    @EnvironmentObject private var store: InventoryViewModel
    @State private var searchText = ""
    @State private var showAddCategory = false
    @EnvironmentObject private var navigationController: NavigationController
    var body: some View {
        let categories = store.filteredOrders(store.categories, searchText: searchText)
        List(categories) { category in
            NavigationLink {
                VerticalProductListView(products: store.productsByCategory(category))
                    .navigationTitle("Products")
                    .environmentObject(InventoryViewModel())
                    .environmentObject(NavigationController())
                    .background(Color.background)
            } label: {
                VStack(alignment: .leading) {
                    Text(category.name)
                        .fontWeight(.semibold)
                    Text("\(store.productsByCategory(category).count) products")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .listRowBackground(Color.background)
        }
        .sheet(isPresented: $showAddCategory) {
            NavigationStack {
                AddCategoryView()
            }
        }
        .scrollIndicators(.hidden)
        .searchable(text: $searchText)
        .navigationTitle("Categories")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddCategory.toggle()
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .listStyle(.plain)
        .background(Color.background)
        .onAppear() {
            store.loadUserData()
        }
        

        
    }
}

#Preview {
    NavigationStack {
        CategoryListView()
            .environmentObject(InventoryViewModel())
    }
}

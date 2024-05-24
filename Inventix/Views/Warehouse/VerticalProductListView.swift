//
//  VerticalProductListView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/2/24.
//

import SwiftUI

struct VerticalProductListView: View {
    @StateObject private var store = InventoryViewModel()
    @State private var searchText = ""
    var products: [Product]
    @EnvironmentObject private var navigationController: NavigationController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List(store.filteredProducts(products, searchText: searchText)) { product in
            NavigationLink {
                ProductDetailView(product: product)
                    .environmentObject(InventoryViewModel())
                    .environmentObject(navigationController)

            } label: {
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: product.imageUrl)) { image in
                        image
                            .resizable()
                            .frame(width: 50, height: 50)
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }
                    
                    VStack(alignment: .leading) {
                        Text(product.name)
                            .fontWeight(.semibold)
                        Text(product.sku)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .listRowBackground(Color.background)
        }
        .listStyle(.plain)
        .background(Color.background)
        .searchable(text: $searchText)
        .onAppear(){
            store.loadUserData()
        }

        .onChange(of: navigationController.shouldReturnToCategoryList) { shouldReturn in
                    if shouldReturn {
                        navigationController.shouldReturnToCategoryList = false
                        presentationMode.wrappedValue.dismiss()  // Dismiss this view

                    }
                }
        
    }
}


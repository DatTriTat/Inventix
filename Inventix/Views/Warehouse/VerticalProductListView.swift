//
//  VerticalProductListView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/2/24.
//

import SwiftUI

struct VerticalProductListView: View {
    @Environment(InventoryViewModel.self) private var store
    @State private var searchText = ""
    var products: [Product]
    
    var body: some View {
        List(store.filteredProducts(products, searchText: searchText)) { product in
            NavigationLink {
                ProductDetailView(product: product)
                    .environment(store)
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
    }
}

#Preview {
    NavigationStack {
        VerticalProductListView(products: Product.example)
            .environment(InventoryViewModel())
    }
}

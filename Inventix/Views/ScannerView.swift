//
//  ScannerView.swift
//  Inventix
//
//  Created by Khanh Chung on 4/14/24.
//

import SwiftUI
import CodeScanner

struct ScannerView: View {
    @StateObject private var store = InventoryViewModel()
    @State private var isPresentingScanner = false
    @State private var scannedCode: String?
    @State private var showAddProduct = false
    @State private var showRestock = false
    @State private var navigateToHome = false

    var body: some View {
        ZStack {
            Button {
                isPresentingScanner.toggle()
            } label: {
                VStack(spacing: 10) {
                    Text("Tap to Scan")
                        .font(.title3)
                    Image(systemName: "qrcode.viewfinder")
                        .font(.system(size: 100))
                }
            }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(codeTypes: [.qr]) { response in
                    if case let .success(result) = response {
                        scannedCode = result.string
                        isPresentingScanner = false
                    }
                }
            }
            .sheet(item: $scannedCode) { code in
                NavigationStack {
                    if let index = store.products.firstIndex(where: { $0.sku == code }) {
                        NavigationLink(destination: RestockView(product: $store.products[index])){
                            Text("Restock Product")
                        }
                    } else if !code.isEmpty {
                        AddProductView(sku: code)
                            .environmentObject(InventoryViewModel())
                    } else {
                        Text("Invalid Code")
                    }
                }
            }
        }
        .onAppear() {
            store.loadUserData()
        }
        .ignoresSafeArea()
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        .background(Color.background)

    }
}

#Preview {
    ScannerView()
        .environmentObject(InventoryViewModel())
}

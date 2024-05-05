//
//  OrderListView.swift
//  Inventix
//
//  Created by Khanh Chung on 3/30/24.
//

import SwiftUI

struct OrderListView: View {
    @Environment(InventoryViewModel.self) private var store
    @State private var searchText = ""
    var orders: [Order]
    
    @State private var selectedSort: OrderSort?
    @State private var selectedFilter: OrderFilter?
    @State private var selectedMonth: String?
    @State private var selectedYear: Int?
    
    var body: some View {
        List(filteredOrders()) { order in
            if let product = store.getProductFromOrder(order) {
                NavigationLink {
                    OrderDetailView(order: order)
                        .environment(store)
                } label: {
                    let isAdded = order.stock > 0
                    
                    VStack(alignment: .leading) {
                        Text(product.name).fontWeight(.semibold)
                        HStack(alignment: .bottom) {
                            Text("\(isAdded ? "+" : "")\(order.stock) (\(order.action))").font(.footnote).foregroundStyle(.secondary)
                            Spacer()
                            Text(order.date, style: .date)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal)
                        }
                    }
                }
                .listRowBackground(Color.background)
            }
        }
        .background(Color.background)
        .listStyle(.plain)
        .navigationTitle("Order History")
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("", selection: $selectedSort.animation()) {
                        ForEach(OrderSort.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(option as OrderSort?)
                        }
                    }
                } label: {
                    Label("Sort By", systemImage: "arrow.up.arrow.down")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("", selection: $selectedFilter.animation()) {
                        ForEach(OrderFilter.allCases, id: \.self) { option in
                            if option == .month {
                                Menu(option.rawValue) {
                                    monthPicker
                                }
                                .tag(option as OrderFilter?)
                            } else {
                                Menu(option.rawValue) {
                                    yearPicker
                                }
                                .tag(option as OrderFilter?)
                            }
                        }
                    }
                } label: {
                    Label("Sort By", systemImage: "line.horizontal.3.decrease.circle")
                }
            }
        }
    }
    
    var monthPicker: some View {
        Picker("", selection: $selectedMonth.animation()) {
            ForEach(Calendar.current.monthSymbols) { month in
                Text(month).tag(month as String?)
            }
        }
    }
    
    var yearPicker: some View {
        Picker("", selection: $selectedYear.animation()) {
            ForEach(2010...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                Text(year.description).tag(year as Int?)
            }
        }
    }
    
    func filteredOrders() -> [Order] {
        var orders = store.filteredOrders(orders, searchText: searchText)
        
        if selectedSort == .oldest {
            orders = orders.sorted { $0.date < $1.date }
        }
        
        if selectedSort == .newest {
            orders = orders.sorted { $0.date > $1.date }
        }
        
        if let selectedMonth {
            orders = orders.filter { $0.date.monthName == selectedMonth }
        }
        
        if let selectedYear {
            orders = orders.filter { Calendar.current.component(.year, from: $0.date) == selectedYear }
        }
        
        return orders
    }
}

enum OrderSort: String, CaseIterable {
    case oldest = "Oldest First"
    case newest = "Newest First"
}

enum OrderFilter: String, CaseIterable {
    case month = "Month"
    case year = "Year"
}

extension Date {
    var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM"
        return nameFormatter.string(from: self)
    }
}

#Preview {
    NavigationStack {
        OrderListView(orders: Order.example)
            .environment(InventoryViewModel())
    }
}

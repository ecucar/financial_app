//
//  StocksView.swift
//  FinancialApp
//
//  Created by Emre Can on 8.06.2026.
//

import SwiftUI

struct StocksView: View {
    @StateObject var marketViewModel = MarketViewModel()
    
    
    @State private var searchText = ""
    
    
    var filteredStocks: [Stock] {
        if searchText.isEmpty {
            return marketViewModel.stocks
        } else {
            return marketViewModel.stocks.filter {
                $0.code.localizedCaseInsensitiveContains(searchText) ||
                $0.text.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            
            // List içindeki kısmı şununla değiştir:
            List(filteredStocks) { stock in
                NavigationLink(destination: StockDetailView(stock: stock)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(stock.code)
                                .font(.headline)
                                .bold()
                            Text(stock.text)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 5) {
                            Text("\(String(format: "%.2f", stock.lastprice ?? 0.0)) ₺")
                                .font(.headline)
                            
                            let safeRate = stock.rate ?? 0.0
                            Text("\(safeRate >= 0 ? "+" : "")\(String(format: "%.2f", safeRate))%")
                                .font(.subheadline)
                                .foregroundColor(safeRate >= 0 ? .green : .red)
                        }
                    }
                    .padding(.vertical, 4)
                }
            
            }
            .navigationTitle("Hisse Senetleri")
            
            .searchable(text: $searchText, prompt: "Hisse veya Şirket Adı Ara")
            .onAppear {
                marketViewModel.loadStocks()
            }
        }
    }
}

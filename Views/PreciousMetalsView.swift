//
//  PreciousMetalsView.swift
//  FinancialApp
//
//  Created by Emre Can on 3.04.2026.
//

import SwiftUI

struct PreciousMetalsView: View {
    @StateObject private var marketViewModel = MarketViewModel()
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if marketViewModel.isLoading {
                    ProgressView("Piyasa verileri güncelleniyor...")
                } else if let errorMessage = marketViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                } else {
                    
                    List(marketViewModel.rates.filter { $0.symbol.contains("Altın") || $0.symbol.contains("Gümüş") }) { currency in
                        NavigationLink(destination: TradeView(selectedCurrency: currency)) {
                            HStack {
                                Image(systemName: "bitcoinsign.circle.fill")
                                    .foregroundColor(.orange)
                                    .font(.title2)
                                
                                Text(currency.symbol)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                Text("₺\(String(format: "%.2f", currency.rate))")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Değerli Madenler")
            .task {
                if marketViewModel.rates.isEmpty {
                    marketViewModel.fetchRates()
                }
            }
        }
    }
}

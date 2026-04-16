//
//  DashboardView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    @StateObject private var marketViewModel = MarketViewModel()
    
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                                VStack(spacing: 8) {
                                    Text("Toplam Varlık")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    
                                    Text("₺\(String(format: "%.2f", portfolioViewModel.balance))")
                                        .font(.system(size: 40, weight: .bold, design: .rounded))
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 20)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(20)
                                .padding(.horizontal)
                                .padding(.top, 10)
                                
                
                if marketViewModel.isLoading {
                    ProgressView("Canlı kurlar çekiliyor...")
                        .scaleEffect(1.2)
                        .padding()
                }
                
                else if let errorMessage = marketViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                else {
                    List(marketViewModel.rates.filter { !($0.symbol.contains("Altın") || $0.symbol.contains("Gümüş")) }) { currency in
                        
                        NavigationLink(destination: TradeView(selectedCurrency: currency)) {
                            HStack {
                                Text(currency.symbol)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                                
                                if currency.symbol.contains("XAU") {
                                    Text("₺\(String(format: "%.2f", currency.rate))")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                        .fontWeight(.bold)
                                } else {
                                    Text(String(format: "%.4f", currency.rate))
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Piyasa Karşılığı")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                }
            }
            
            .task {
                if marketViewModel.rates.isEmpty {
                    marketViewModel.fetchRates()
                }
                portfolioViewModel.loadPortfolio()
            
            }
           
        }
        .environmentObject(portfolioViewModel)
    }
}

#Preview {
    DashboardView()
        .environmentObject(AuthViewModel())
}

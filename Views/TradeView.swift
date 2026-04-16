//
//  TradeView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI

struct TradeView: View {
    let selectedCurrency: CurrencyRate
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    
    @State private var amountText: String = ""
    @State private var isProcessing = false
    
    var amount: Double {
        Double(amountText.replacingOccurrences(of: ",", with: ".")) ?? 0.0
    }
    
    var totalValue: Double {
        amount * selectedCurrency.rate
    }
    
    var isBalanceSufficient: Bool {
        totalValue <= portfolioViewModel.balance
    }
    
    
    var currentAssetAmount: Double {
        portfolioViewModel.assets[selectedCurrency.symbol] ?? 0.0
    }
    
    var body: some View {
        VStack(spacing: 30) {
            
            VStack(spacing: 5) {
                Text("\(selectedCurrency.symbol) İşlem Tahtası")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Güncel Fiyat: ₺\(String(format: "%.4f", selectedCurrency.rate))")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
            .padding(.top, 20)
            
            
            VStack(spacing: 8) {
                Text("Kullanılabilir Bakiye: ₺\(String(format: "%.2f", portfolioViewModel.balance))")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                
                Text("Sahip Olduğunuz: \(String(format: "%.2f", currentAssetAmount)) \(selectedCurrency.symbol)")
                    .font(.headline)
                    .foregroundColor(.orange)
            }
            
            VStack(alignment: .leading) {
                Text("Alınacak/Satılacak Miktar (\(selectedCurrency.symbol))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("0", text: $amountText)
                    .keyboardType(.decimalPad)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
            }
            .padding(.horizontal)
            
            HStack {
                Text("Toplam Tutar:")
                    .font(.title3)
                Spacer()
                Text("₺\(String(format: "%.2f", totalValue))")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(isBalanceSufficient ? .primary : .red)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 20) {
                
                Button {
                    isProcessing = true
                    Task {
                        do {
                            let service = PortfolioService()
                            try await service.buyAsset(symbol: selectedCurrency.symbol, amount: amount, totalCost: totalValue)
                            
                            
                            portfolioViewModel.loadPortfolio()
                            
                            amountText = ""
                            isProcessing = false
                        } catch {
                            print("İşlem hatası: \(error.localizedDescription)")
                            isProcessing = false
                        }
                    }
                } label: {
                    Group {
                        if isProcessing {
                            ProgressView().tint(.white)
                        } else {
                            Text("AL")
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(15)
                }
                .disabled(amount <= 0 || !isBalanceSufficient || isProcessing)
                .opacity((amount <= 0 || !isBalanceSufficient || isProcessing) ? 0.4 : 1.0)
                
                
                Button {
                    isProcessing = true
                    Task {
                        do {
                            let service = PortfolioService()
                            
                            try await service.sellAsset(symbol: selectedCurrency.symbol, amount: amount, totalRevenue: totalValue)
                            
                            portfolioViewModel.loadPortfolio()
                            
                            amountText = ""
                            isProcessing = false
                        } catch {
                            print("İşlem hatası: \(error.localizedDescription)")
                            isProcessing = false
                        }
                    }
                } label: {
                    Group {
                        if isProcessing {
                            ProgressView().tint(.white)
                        } else {
                            Text("SAT")
                        }
                    }
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
                }
                // 
                .disabled(amount <= 0 || amount > currentAssetAmount || isProcessing)
                .opacity((amount <= 0 || amount > currentAssetAmount || isProcessing) ? 0.4 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding()
        .navigationTitle("İşlem: \(selectedCurrency.symbol)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

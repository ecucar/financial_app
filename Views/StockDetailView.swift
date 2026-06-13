//
//  StockDetailView.swift
//  FinancialApp
//
//  Created by Emre Can on 8.06.2026.
//

import SwiftUI


struct StockDetailView: View {
    let stock: Stock
    @StateObject var portfolioVM = PortfolioViewModel() // Alım-satım işlemleri için
    @State private var amountText = "" // Alınacak adet
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 30) {
            // Hisse Bilgi Kartı
            VStack(spacing: 10) {
                Text(stock.code)
                    .font(.system(size: 60, weight: .bold))
                Text(stock.text)
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Text("\(String(format: "%.2f", stock.lastprice ?? 0.0)) ₺")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            }
            .padding(.top)
            
            // Alım-Satım Girişi
            VStack(alignment: .leading, spacing: 10) {
                Text("İşlem Miktarı (Adet)")
                    .font(.headline)
                
                TextField("Kaç adet hisse?", text: $amountText)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
                Text("Toplam Tutar: \(calculateTotal()) ₺")
                    .font(.subheadline)
                    .bold()
            }
            .padding(.horizontal)
            
            // Butonlar
            HStack(spacing: 20) {
                // SAT BUTONU
                Button(action: { executeTrade(isBuy: false) }) {
                    Text("SAT")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                // AL BUTONU
                Button(action: { executeTrade(isBuy: true) }) {
                    Text("AL")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle(stock.code)
        .alert("İşlem Durumu", isPresented: $showAlert) {
            Button("Tamam", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // Toplam tutar hesaplama
    func calculateTotal() -> String {
        let amount = Double(amountText) ?? 0.0
        let total = amount * (stock.lastprice ?? 0.0)
        return String(format: "%.2f", total)
    }
    
    // Alım veya Satım işlemini gerçekleştirme
    func executeTrade(isBuy: some Any) {
        guard let amount = Double(amountText), amount > 0 else {
            alertMessage = "Lütfen geçerli bir miktar girin."
            showAlert = true
            return
        }
        
        let totalCost = amount * (stock.lastprice ?? 0.0)
        
        Task {
            do {
                if isBuy as! Bool {
                    // Cüzdan bakiyesi kontrolü burada PortfolioService içinde yapılacak
                    try await portfolioVM.portfolioService.buyAsset(symbol: stock.code, amount: amount, totalCost: totalCost)
                    alertMessage = "\(amount) adet \(stock.code) başarıyla alındı!"
                } else {
                    // Satım işlemi
                    try await portfolioVM.portfolioService.sellAsset(symbol: stock.code, amount: amount, totalRevenue: totalCost)
                    alertMessage = "\(amount) adet \(stock.code) başarıyla satıldı!"
                }
                showAlert = true
                amountText = "" // İşlemden sonra kutuyu temizle
            } catch {
                alertMessage = "İşlem başarısız: Bakiyeniz yetersiz olabilir."
                showAlert = true
            }
        }
    }
}


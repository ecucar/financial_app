//
//  TransactionHistoryView.swift
//  FinancialApp
//
//  Created by Emre Can on 7.06.2026.
//

import SwiftUI

struct TransactionHistoryView: View {
    // ViewModel'ini buraya bağlıyoruz (Senin projendeki tanımlamaya göre @EnvironmentObject da olabilir)
    @StateObject private var viewModel = PortfolioViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.transactions) { islem in
                HStack {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(islem.islemTuru) - \(islem.varlik)")
                            .font(.headline)
                            
                            .foregroundColor(islem.islemTuru == "SATIM" ? .red : .green)
                        
                        Text(islem.tarih.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(String(format: "%.2f", islem.miktar)) \(islem.varlik == "TL" ? "₺" : islem.varlik)")
                            .font(.headline)
                        
                        Text("Kur: \(String(format: "%.2f", islem.fiyat))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("İşlem Geçmişi")
            .onAppear {
                
                viewModel.fetchTransactions()
            }
        }
    }
}

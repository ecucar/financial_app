//
//  DepositView.swift
//  FinancialApp
//
//  Created by Emre Can on 13.04.2026.
//

import SwiftUI

struct DepositView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @State private var amountText = ""
    @State private var isProcessing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Image(systemName: "arrow.down.bankbuilding.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top)

                VStack(alignment: .leading) {
                    Text("Yüklenecek Tutar (₺)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextField("Örn: 5000", text: $amountText)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(20)

                Button {
                    transferMoney()
                } label: {
                    if isProcessing {
                        ProgressView().tint(.white)
                    } else {
                        Text("Bakiyeye Aktar")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
                .disabled(amountText.isEmpty || isProcessing)

                Spacer()
            }
            .padding()
            .navigationTitle("Para Yükle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
            }
        }
    }

    func transferMoney() {
        guard let amount = Double(amountText.replacingOccurrences(of: ",", with: ".")) else { return }
        isProcessing = true
        
        Task {
            let service = PortfolioService()
            do {
                try await service.depositMoney(amount: amount)
                portfolioViewModel.loadPortfolio() 
                dismiss()
            } catch {
                print("Hata: \(error.localizedDescription)")
                isProcessing = false
            }
        }
    }
}

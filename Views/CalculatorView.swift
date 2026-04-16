//
//  CalculatorView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Tutar (₺):")
                            .fontWeight(.bold)
                        TextField("Örn: 50000", text: $viewModel.amountText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Vade (Ay):")
                            .fontWeight(.bold)
                        TextField("Örn: 12", text: $viewModel.monthText)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(15)
                .padding(.horizontal)
                
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Banka teklifleri alınıyor...")
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error).foregroundColor(.red)
                    Spacer()
                } else {
                    List(viewModel.creditOffers) { offer in
                        let rate = offer.faizOrani
                        let monthly = viewModel.calculateMonthlyPayment(for: rate)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(offer.bank ?? "Bilinmeyen Banka")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text("%\(String(format: "%.2f", rate))")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Aylık Taksit:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("₺\(String(format: "%.2f", monthly))")
                                    .font(.headline)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Canlı Kredi Teklifleri")
            .onAppear {
                if viewModel.creditOffers.isEmpty {
                    viewModel.loadLiveCredits()
                }
            }
        }
    }
}

//
//  CalculatorView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI

struct CalculatorView: View {
    @StateObject private var viewModel = CalculatorViewModel()
    
    @State private var selectedTab = 0
    var body: some View {
        NavigationStack {
            VStack {
                Picker("İşlem Türü", selection: $selectedTab) {
                    Text("Kredi Faizleri").tag(0)
                    Text("Mevduat Hesapla").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 10)
                if selectedTab == 0 {
                    
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
                }else {
                    depositView
                }
            }
            .navigationTitle("Krediler ve Mevduat")
            .onAppear {
                if viewModel.creditOffers.isEmpty {
                    viewModel.loadLiveCredits()
                }
            }
        }
    }
    
    
    private var depositView: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                VStack(spacing: 15) {
                    HStack {
                        Text("Tutar (₺):")
                            .bold()
                        TextField("Örn: 100000", text: $viewModel.depositAmount)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                            .onChange(of: viewModel.depositAmount) { oldValue, newValue in viewModel.calculateDeposit()
                            }                    }
                    
                    HStack {
                        Text("Yıllık Faiz (%):")
                            .bold()
                        TextField("Örn: 43.5", text: $viewModel.depositRate)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.depositRate) { oldValue, newValue in viewModel.calculateDeposit()
                            }
                    }
                    
                    HStack {
                        Text("Vade (Gün):")
                            .bold()
                        TextField("Örn: 32", text: $viewModel.depositDays)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .onChange(of: viewModel.depositDays) { oldValue, newValue in viewModel.calculateDeposit()
                            }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
                
                
                VStack(spacing: 15) {
                    Text("Seçilen Gün Sonunda")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("Net Getiri:")
                            .font(.title3)
                        Spacer()
                        Text("+₺\(String(format: "%.2f", viewModel.netDepositReturn))")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Toplam Bakiye:")
                            .font(.title3)
                        Spacer()
                        Text("₺\(String(format: "%.2f", viewModel.totalDepositBalance))")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                    }
                    
                    Text("Brüt getiri üzerinden %17.5 stopaj kesintisi uygulanmıştır.")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                }
                .padding()
                .background(Color.green.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
                .cornerRadius(15)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
    }
    
    
}

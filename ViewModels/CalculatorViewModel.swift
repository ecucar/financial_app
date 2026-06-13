//
//  CalculatorViewModel.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CalculatorViewModel: ObservableObject {
    @Published var creditOffers: [CreditOffer] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    
    @Published var amountText: String = "50000"
    @Published var monthText: String = "12"
    
    
    @Published var depositAmount: String = ""
    @Published var depositRate: String = "" 
    @Published var netDepositReturn: Double = 0.0
    @Published var totalDepositBalance: Double = 0.0
    @Published var depositDays: String = "32"
    
    private let marketService = MarketDataService()
    
    func loadLiveCredits() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let gelenTeklifler = try await marketService.fetchCreditRates()
                
                self.creditOffers = gelenTeklifler.sorted { $0.faizOrani < $1.faizOrani }
                self.isLoading = false
            } catch {
                self.errorMessage = "Kredi faizleri çekilemedi."
                self.isLoading = false
            }
        }
    }
    
    
    func calculateMonthlyPayment(for rate: Double) -> Double {
        guard let amount = Double(amountText), let months = Double(monthText), amount > 0, months > 0 else {
            return 0.0
        }
        
        if rate == 0 { return amount / months }
        
        let r = rate / 100.0
        
        let mathPower = pow(1.0 + r, months)
        let monthlyPayment = amount * (r * mathPower) / (mathPower - 1.0)
        
        
        
        return monthlyPayment * 1.30
    }
    
    
    func calculateDeposit() {
            guard let amount = Double(depositAmount),
                  let rate = Double(depositRate),
                  let days = Double(depositDays), days > 0 else {
                netDepositReturn = 0.0
                totalDepositBalance = 0.0
                return
            }
            
            
            let brutGetiri = amount * (rate / 100.0) * (days / 365.0)
            
            
            let stopaj = brutGetiri * 0.175
            let netGetiri = brutGetiri - stopaj
            
            self.netDepositReturn = netGetiri
            self.totalDepositBalance = amount + netGetiri
        }
    
}

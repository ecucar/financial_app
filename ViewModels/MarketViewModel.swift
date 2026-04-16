//
//  MarketViewModel.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class MarketViewModel: ObservableObject {
    
    
    @Published var rates: [CurrencyRate] = []
    
    
    @Published var isLoading = false
    
    
    @Published var errorMessage: String? = nil
    
    
    private let marketService = MarketDataService()
    
    
    func fetchRates() {
            isLoading = true
            errorMessage = nil
            
            Task {
                do {
                    
                    let fetchedRates = try await marketService.fetchExchangeRates()
                    
                    self.rates = fetchedRates
                    self.isLoading = false
                } catch {
                    self.errorMessage = "Piyasa verileri şu an alınamıyor."
                    self.isLoading = false
                    print("Hata: \(error.localizedDescription)")
                }
            }
        
        }
    }


//
//  PortfolioViewModel.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PortfolioViewModel: ObservableObject {
    
    @Published var balance: Double = 0.0
    
    @Published var assets: [String: Double] = [:]
    
    private let portfolioService = PortfolioService()
    
    func loadPortfolio() {
        Task {
            do {
                
                let portfolio = try await portfolioService.fetchPortfolio()
                self.balance = portfolio.balance
                self.assets = portfolio.assets
            } catch {
                print("Portföy çekilemedi: \(error.localizedDescription)")
            }
        }
    }
}

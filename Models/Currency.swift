//
//  Currency.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation


struct CurrencyResponse: Codable {
    let amount: Double
    let base: String
    let date: String
    let rates: [String: Double]
}


struct CurrencyRate: Identifiable {
    let id = UUID()
    let symbol: String
    let rate: Double
}

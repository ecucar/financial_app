//
//  Stock.swift
//  FinancialApp
//
//  Created by Emre Can on 8.06.2026.
//

import Foundation

struct StockResponse: Codable {
    let success: Bool
    let result: [Stock]
}

struct Stock: Codable, Identifiable {
    var id: String { code }     
    let code: String
    let text: String
    let lastprice: Double?
    let rate: Double?
}

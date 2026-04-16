//
//  MarketDataService.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation

struct CollectAPIResponse: Codable {
    let success: Bool
    let result: [CollectCurrency]?
}

struct CollectCurrency: Codable {
    let name: String
    let code: String?
    let text: String?
    let buying: Double?
    let selling: Double?
}


struct CreditResponse: Codable {
    let success: Bool
    let result: [CreditOffer]?
}

struct CreditOffer: Codable, Identifiable {
    let bank: String?
    let faiz: String?
    
    var id: String { return bank ?? UUID().uuidString }
    
    var faizOrani: Double {
        
        let temizFaiz = faiz?.replacingOccurrences(of: "%", with: "").replacingOccurrences(of: ",", with: ".")
        return Double(temizFaiz ?? "0.0") ?? 0.0
    }
}

class MarketDataService {
    private let apiKey = Secrets.collectApiKey
    
    func fetchExchangeRates() async throws -> [CurrencyRate] {
        
        let currencyUrl = URL(string: "https://api.collectapi.com/economy/allCurrency")!
        var currencyRequest = URLRequest(url: currencyUrl)
        currencyRequest.addValue(apiKey, forHTTPHeaderField: "authorization")
        
        let (currencyData, _) = try await URLSession.shared.data(for: currencyRequest)
        let currencyRes = try JSONDecoder().decode(CollectAPIResponse.self, from: currencyData)
        
        
        let goldUrl = URL(string: "https://api.collectapi.com/economy/goldPrice")!
        var goldRequest = URLRequest(url: goldUrl)
        goldRequest.addValue(apiKey, forHTTPHeaderField: "authorization")
        
        let (goldData, _) = try await URLSession.shared.data(for: goldRequest)
        let goldRes = try JSONDecoder().decode(CollectAPIResponse.self, from: goldData)
        
        var finalRates: [CurrencyRate] = []
        
        
        if let currencies = currencyRes.result {
            for item in currencies where ["USD", "EUR", "GBP"].contains(item.code) {
                finalRates.append(CurrencyRate(symbol: item.code ?? "", rate: item.selling ?? 0.0))
            }
        }
        
        
        if let golds = goldRes.result {
            for item in golds where ["Gram Altın", "Çeyrek Altın"].contains(item.name) {
                finalRates.append(CurrencyRate(symbol: item.name, rate: item.selling ?? 0.0))
            }
        }
        
        return finalRates
    }
    
    func fetchCreditRates() async throws -> [CreditOffer] {
            
            let urlString = "https://api.collectapi.com/credit/ihtiyacKredi"
            guard let url = URL(string: urlString) else { throw URLError(.badURL) }
            
            var request = URLRequest(url: url)
            request.addValue(apiKey, forHTTPHeaderField: "authorization")
            request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(CreditResponse.self, from: data)
            return response.result ?? []
        }
    
}

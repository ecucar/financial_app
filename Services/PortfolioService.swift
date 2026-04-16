//
//  PortfolioService.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class PortfolioService {
    
    private let db = Firestore.firestore()
    
    
    func fetchPortfolio() async throws -> (balance: Double, assets: [String: Double]) {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw URLError(.userAuthenticationRequired)
        }
        
        let document = try await db.collection("users").document(uid).getDocument()
        
        var currentBalance = 0.0
        var currentAssets: [String: Double] = [:]
        
        if let data = document.data() {
            currentBalance = data["balance"] as? Double ?? 0.0
            currentAssets = data["assets"] as? [String: Double] ?? [:]
        }
        
        return (currentBalance, currentAssets)
    }
    
    
    func buyAsset(symbol: String, amount: Double, totalCost: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw URLError(.userAuthenticationRequired) }
        let userRef = db.collection("users").document(uid)
        
        try await userRef.updateData([
            "balance": FieldValue.increment(-totalCost),
            "assets.\(symbol)": FieldValue.increment(amount)
        ])
    }
    
    
    func sellAsset(symbol: String, amount: Double, totalRevenue: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw URLError(.userAuthenticationRequired) }
        let userRef = db.collection("users").document(uid)
        
        try await userRef.updateData([
            "balance": FieldValue.increment(totalRevenue),
            "assets.\(symbol)": FieldValue.increment(-amount)
        ])
    }
    
    func depositMoney(amount: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw URLError(.userAuthenticationRequired) }
        let userRef = db.collection("users").document(uid)
        
        
        try await userRef.updateData([
            "balance": FieldValue.increment(amount)
        ])
    }
}

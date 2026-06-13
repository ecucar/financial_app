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
        try await logTransaction(islemTuru: "ALIM", varlik: symbol, miktar: amount, fiyat: (totalCost / amount))
    }
    
    
    func sellAsset(symbol: String, amount: Double, totalRevenue: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw URLError(.userAuthenticationRequired) }
        let userRef = db.collection("users").document(uid)
        
        try await userRef.updateData([
            "balance": FieldValue.increment(totalRevenue),
            "assets.\(symbol)": FieldValue.increment(-amount)
        ])
        try await logTransaction(islemTuru: "SATIM", varlik: symbol, miktar: amount, fiyat: (totalRevenue / amount))
    }
    
    func depositMoney(amount: Double) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { throw URLError(.userAuthenticationRequired) }
        let userRef = db.collection("users").document(uid)
        
        
        try await userRef.updateData([
            "balance": FieldValue.increment(amount)
        ])
        
        try await logTransaction(islemTuru: "YÜKLEME", varlik: "TL", miktar: amount, fiyat: 1.0)
    }
    
    
    
        func logTransaction(islemTuru: String, varlik: String, miktar: Double, fiyat: Double) async throws {
            
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Hata: Kullanıcı bulunamadı.")
                return
            }
            
            let islemId = UUID().uuidString
            
            
            let islemData: [String: Any] = [
                "id": islemId,
                "islemTuru": islemTuru,
                "varlik": varlik,
                "miktar": miktar,
                "fiyat": fiyat,
                "tarih": Timestamp(date: Date()) 
            ]
            
            
            let db = Firestore.firestore()
            try await db.collection("users").document(uid).collection("transactions").document(islemId).setData(islemData)
        }
    
    
}

//
//  PortfolioViewModel.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

@MainActor
class PortfolioViewModel: ObservableObject {
    
    @Published var transactions: [TransactionLog] = []
    
    @Published var balance: Double = 0.0
    
    @Published var assets: [String: Double] = [:]
    
     let portfolioService = PortfolioService()
    
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
    
    func fetchTransactions() {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let db = Firestore.firestore()
            
            
            db.collection("users").document(uid).collection("transactions")
                .order(by: "tarih", descending: true)
                .addSnapshotListener { snapshot, error in
                    guard let documents = snapshot?.documents else {
                        print("İşlem geçmişi çekilemedi: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                        return
                    }
                    
                    
                    self.transactions = documents.compactMap { doc -> TransactionLog? in
                        let data = doc.data()
                        
                        guard let id = data["id"] as? String,
                              let islemTuru = data["islemTuru"] as? String,
                              let varlik = data["varlik"] as? String,
                              let miktar = data["miktar"] as? Double,
                              let fiyat = data["fiyat"] as? Double,
                              let timestamp = data["tarih"] as? Timestamp else {
                            return nil
                        }
                        
                        return TransactionLog(
                            id: id,
                            islemTuru: islemTuru,
                            varlik: varlik,
                            miktar: miktar,
                            fiyat: fiyat,
                            tarih: timestamp.dateValue()
                        )
                    }
                }
        }
    
}

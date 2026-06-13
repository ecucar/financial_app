//
//  TransactionLog.swift
//  FinancialApp
//
//  Created by Emre Can on 6.06.2026.
//

import Foundation
import FirebaseFirestore 

struct TransactionLog: Identifiable {
    let id: String
    let islemTuru: String
    let varlik: String
    let miktar: Double
    let fiyat: Double
    let tarih: Date
}

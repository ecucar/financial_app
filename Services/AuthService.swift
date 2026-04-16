//
//  AuthService.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    
    private let db = Firestore.firestore()
    
    
    func createUser(email: String, password: String) async throws -> AuthDataResult {
        
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        
        
        let userData: [String: Any] = [
            "email": email,
            "balance": 0.0,
            "createdAt": Timestamp(date: Date())
        ]
        
        
        try await db.collection("users").document(result.user.uid).setData(userData)
        
        return result
    }
    
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result
    }
    
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}

//
//  AuthViewModel.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

@MainActor 
class AuthViewModel: ObservableObject {
    
    @Published var currentUser: User?
    @Published var errorMessage = ""
    
    private let authService = AuthService()
    
    init() {
        self.currentUser = Auth.auth().currentUser
    }
    
    func login(email: String, password: String) async {
        do {
            let result = try await authService.signIn(email: email, password: password)
            self.currentUser = result.user
            print("Giriş başarılı: \(result.user.uid)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Giriş hatası: \(error.localizedDescription)")
        }
    }
    
    func register(email: String, password: String) async {
        do {
            let result = try await authService.createUser(email: email, password: password)
            self.currentUser = result.user
            print("Kayıt başarılı: \(result.user.uid)")
        } catch {
            self.errorMessage = error.localizedDescription
            print("Kayıt hatası: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
            do {
                try authService.signOut()
                self.currentUser = nil
            } catch {
                print("Çıkış yapılamadı: \(error.localizedDescription)")
            }
        }
}

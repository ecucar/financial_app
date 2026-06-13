//
//  FinancialAppApp.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI
import FirebaseCore

@main
struct FinancialAppApp: App {
    
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView() //
        }
    }
}

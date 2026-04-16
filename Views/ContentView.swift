//
//  ContentView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
                    if viewModel.currentUser != nil {
                        MainTabView() 
                    } else {
                
                LoginView()
            }
        }
        
        .environmentObject(viewModel)
    }
}

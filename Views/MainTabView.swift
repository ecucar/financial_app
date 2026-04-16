//
//  MainTabView.swift
//  FinancialApp
//
//  Created by Emre Can on 3.04.2026.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var portfolioViewModel = PortfolioViewModel()
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Label("Ana Sayfa", systemImage: "house.fill")
                }
            
            
            DashboardView()
                .tabItem {
                    Label("Döviz", systemImage: "dollarsign.circle")
                }
            
            
            PreciousMetalsView()
                .tabItem {
                    Label("Madenler", systemImage: "bitcoinsign.circle")
                }
            
            
            CalculatorView()
                .tabItem {
                    Label("Hesaplama", systemImage: "percent")
                }
        }
        .tint(.blue)
        .environmentObject(portfolioViewModel)
    }
}

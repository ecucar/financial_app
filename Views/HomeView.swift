//
//  HomeView.swift
//  FinancialApp
//
//  Created by Emre Can on 3.04.2026.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var showDepositSheet = false
    @State private var signOutError: String? = nil
    @EnvironmentObject var portfolioViewModel: PortfolioViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 25) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Hoş Geldin")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("Finans Portföyün")
                                .font(.title.bold())
                        }
                        Spacer()
                        


                        Menu {
                            Button(role: .destructive) {
                                
                                authViewModel.signOut()
                            } label: {
                                Label("Çıkış Yap", systemImage: "rectangle.portrait.and.arrow.right")
                            }
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 45))
                                .foregroundColor(.blue)
                        }
                        
                        .alert("Çıkış yapılamadı", isPresented: .constant(signOutError != nil), actions: {
                            Button("Tamam") { signOutError = nil }
                        }, message: {
                            Text(signOutError ?? "Bilinmeyen bir hata oluştu.")
                        })
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("HESAP BAKİYENİZ")
                            .font(.caption)
                            .fontWeight(.bold)
                            .opacity(0.8)
                        
                        Text("₺\(String(format: "%.2f", portfolioViewModel.balance))")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                        
                        
                    }
                    .padding(25)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .foregroundColor(.white)
                    .cornerRadius(25)
                    .padding(.horizontal)
                    

                    Button {
                        showDepositSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Para Yükle")
                                .fontWeight(.semibold)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .sheet(isPresented: $showDepositSheet) {
                        DepositView()
                            .presentationDetents([.medium])
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Portföy Dağılımınız")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if portfolioViewModel.assets.isEmpty {
                            Text("Henüz bir varlığınız bulunmuyor.")
                                .foregroundColor(.secondary)
                                .padding()
                        } else {
                            
                            ForEach(portfolioViewModel.assets.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                if value > 0 {
                                    HStack {
                                        Text(key).fontWeight(.bold)
                                        Spacer()
                                        Text("\(String(format: "%.2f", value)) ")
                                    }
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Özet")
            .onAppear {
                portfolioViewModel.loadPortfolio()
            }
        }
    }
}


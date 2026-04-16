//
//  LoginView.swift
//  FinancialApp
//
//  Created by Emre Can on 23.03.2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoginMode = true 
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                // Başlık ve İkon
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                Text(isLoginMode ? "Tekrar Hoşgeldiniz" : "Hesap Oluşturun")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                
                VStack(spacing: 15) {
                    TextField("E-posta adresiniz", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    SecureField("Şifreniz", text: $password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                
                Button {
                    Task {
                        if isLoginMode {
                            await viewModel.login(email: email, password: password)
                        } else {
                            await viewModel.register(email: email, password: password)
                        }
                    }
                }label: {
                    Text(isLoginMode ? "Giriş Yap" : "Kayıt Ol")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                
                Button {
                    withAnimation {
                        isLoginMode.toggle()
                    }
                } label: {
                    Text(isLoginMode ? "Hesabınız yok mu? Kayıt olun." : "Zaten hesabınız var mı? Giriş yapın.")
                        .foregroundColor(.blue)
                        .font(.footnote)
                }
                
                Spacer()
            }
            .navigationTitle(isLoginMode ? "Giriş" : "Kayıt")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LoginView()
}

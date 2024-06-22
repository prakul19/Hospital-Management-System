//
//  LoginView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//


import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingHomeView = false
    @State private var showingCreateAccount = false
    @State private var isLoading = false // Add isLoading state
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    VStack {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .padding(10)
                        
                        Text("Hospital Connect")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.green)
                    }
                    
                    VStack {
                        InputView(text: $email, placeholder: "Email").textInputAutocapitalization(.never)
                        InputView(text: $password, placeholder: "Password", isSecureField: true)
                    }
                    
                    Button(action: {
                        isLoading = true // Show loader
                        viewModel.loginUser(email: email, password: password) { result in
                            isLoading = false // Hide loader after completion
                            switch result {
                            case .success(let token):
                                print("Login successful, token: \(token)")
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                                print("Login error: \(error)")
                            }
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(100)
                            .padding(.horizontal)
                    }
                    
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding()
                
                if isLoading {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .scaleEffect(2)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    LoginView().environmentObject(AuthViewModel())
}

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
    @State private var isLoading = false // Added state for loading indicator
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
                        
                        Text("Hosp Connect")
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
                        if email.isEmpty || password.isEmpty {
                            errorMessage = "Please enter both email and password."
                        } else {
                            isLoading = true // Show loading indicator
                            viewModel.loginUser(email: email, password: password) { result in
                                switch result {
                                case .success(let token):
                                    print("Login successful, token: \(token)")
                                    // Optionally, you can navigate to the next page here
                                case .failure(let error):
                                    if case .authenticationFailed = error {
                                        errorMessage = "Your email or password is incorrect. Please check them and try again."
                                    } else {
                                        errorMessage = "Login error: \(error.localizedDescription)"
                                    }
                                }
                                isLoading = false // Hide loading indicator
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

                    Button(action: {
                        self.showingCreateAccount = true
                    }) {
                        Text("Don't have an account? Register")
                            .font(.footnote)
                            .foregroundColor(.green)
                    }
                    NavigationLink(destination: RegisterView(), isActive: self.$showingCreateAccount) {
                        EmptyView()
                    }
                }
                .padding()
                .padding(.bottom, 50)
                
                if isLoading {
                    Color.black.opacity(0.5) // Transparent background covering the entire screen
                        .edgesIgnoringSafeArea(.all)
                    ProgressView() // Loader displayed on top
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2) // Increase size of the loader
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    LoginView().environmentObject(AuthViewModel())
}

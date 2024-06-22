//
//  OTPView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct OTPView: View {
    @State private var otpCode: String = ""
    @State private var errorMessage = ""
    @State private var successMessage = ""
    @State private var showingLoginScreen = false
    var email: String
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("OTP Verification")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.green)
            
            Text("Hello User,")
            Text("Thank you for registering with us. Please type the OTP shared on your email \(email).")
                .multilineTextAlignment(.center)
            
            VStack {
                CustomTextField(placeholder: "XXX - XXX", text: $otpCode)
                    .frame(height: 50)
                    .padding()
                    .keyboardType(.numberPad)
                    .frame(width: UIScreen.main.bounds.width / 2)
            }
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green))
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }
            
            Button(action: {
                viewModel.submitOTP(otpCode: otpCode) { result in
                    switch result {
                    case .success(let token):
                        print("User created successfully! \(token)")
                        
                    case .failure(let error):
                        print("Error creating \(error)")
                    }
                }

            }) {
                Text("Submit OTP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .center) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(UIColor.placeholderText))
                    .font(.headline) // Increase font size
                    .padding(.horizontal, 8)
            }
            TextField("", text: $text)
                .foregroundColor(.primary)
                .font(.headline) // Increase font size
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .onChange(of: text) { newValue in
                    if newValue.count > 6 {
                        text = String(newValue.prefix(6))
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#Preview {
    OTPView(email:"fda").environmentObject(AuthViewModel())
}

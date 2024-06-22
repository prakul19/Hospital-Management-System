//
//  InputView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct InputView: View {
    @Binding var text : String
    let placeholder : String
    var isSecureField = false
    
    var body: some View {
        if isSecureField{
            SecureField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .frame(height: 60)
                .padding(.horizontal)
        }
        else{
            TextField(placeholder, text: $text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .frame(height: 60)
                .padding(.horizontal)
        }
    }
}

#Preview {
    InputView(text: .constant(""), placeholder: "Email Address")
}

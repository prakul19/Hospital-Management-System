//
//  PrivacyPolicyView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
            
                
                Text("Information Collection")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("We collect personal information, such as name, email address, and demographic information, when you register with our application.")
                
                Text("Use of Information")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("The information we collect is used to personalize your experience, improve our services, and communicate with you.")
                
                Text("Data Sharing")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("We do not share your personal information with third parties unless required by law or to fulfill the purposes outlined in this policy.")
                
                Text("Security Measures")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("We take appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction.")
                
                Text("User Rights")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("You have the right to access, update, or delete your personal information. You can exercise these rights by contacting us.")
            }
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PrivacyPolicyView()
        }
    }
}


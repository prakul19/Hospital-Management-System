//
//  TermsofServiceView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
               
                Text("Acceptance of Terms")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("By using our application, you agree to abide by the following terms and conditions.")
                
                Text("User Conduct")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("You agree not to engage in any conduct that violates the rights of others, including but not limited to harassment, defamation, or infringement of intellectual property.")
                
                Text("Intellectual Property")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("All content provided in this application, including text, graphics, logos, and images, is the property of the application developer and is protected by intellectual property laws.")
                
                Text("Limitation of Liability")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("We shall not be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of our application.")
                
                Text("Termination")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("We reserve the right to terminate or suspend your access to the application at any time for any reason without notice.")
            }
            .padding()
        }
        .navigationTitle("Terms of Service")
    }
}

struct TermsOfServiceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TermsOfServiceView()
        }
    }
}


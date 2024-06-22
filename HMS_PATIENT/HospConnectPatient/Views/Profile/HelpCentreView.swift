//
//  HelpCentreView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct HelpCenterView: View {
    var body: some View {
        List {
            // FAQs Section
            Section(header: Text("Frequently Asked Questions")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                NavigationLink(destination: FAQView()) {
                    Text("View FAQs")
                }
            }
            
            // Contact Support Section
            Section(header: Text("Contact Support")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("Phone: (123) 456-7890")
                Text("Email: support@hospital.com")
                NavigationLink(destination: ContactFormView()) {
                    Text("Submit a Query")
                }
            }
            
            // User Guide Section
            Section(header: Text("User Guide")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                NavigationLink(destination: UserGuideView()) {
                    Text("Read the User Guide")
                }
            }
            
            // Troubleshooting Tips Section
            Section(header: Text("Troubleshooting Tips")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                NavigationLink(destination: TroubleshootingView()) {
                    Text("Common Issues and Solutions")
                }
            }
            
            // Privacy Policy and Terms of Service Section
            Section(header: Text("Legal")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                NavigationLink(destination: PrivacyPolicyView()) {
                    Text("Privacy Policy")
                }
                NavigationLink(destination: TermsOfServiceView()) {
                    Text("Terms of Service")
                }
            }
        }
        .navigationTitle("Help Center")
    }
}

struct HelpCenterView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HelpCenterView()
        }
    }
}

    
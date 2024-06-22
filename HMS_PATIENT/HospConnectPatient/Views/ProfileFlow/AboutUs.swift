//
//  AboutUs.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 07/06/24.
//
import SwiftUI

struct AboutUsView2: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("About HospConnect")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                    
                    Text("HospConnect is a patient-focused app designed to streamline your healthcare experience at our hospital. With features like appointment scheduling, prescription management, and real-time notifications, we aim to provide you with convenient access to our services.")
                        .font(.body)
                        .foregroundColor(Color(.secondaryLabel))
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer() // Move Spacer here to push the Contact Us section to the left
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Contact Us")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                    
                    Button(action: {
                        // Action to compose email
                        if let url = URL(string: "mailto:hospconnect5@gmail.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(Color(.systemBlue))
                            Text("hospconnect5@gmail.com")
                                .foregroundColor(Color(.systemBlue))
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(15)
                .shadow(color: Color(.black).opacity(0.1), radius: 5, x: 0, y: 5)
                Spacer() // Add Spacer here to push the Contact Us section to the left
            }
        }
        .padding()
        .offset(y: -100)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black) // Customize color as needed
            }
        )
        .navigationBarTitle("About Us", displayMode: .inline)
    }
}


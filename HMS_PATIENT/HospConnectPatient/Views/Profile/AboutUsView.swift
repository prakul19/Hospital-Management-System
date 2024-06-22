//
//  AboutUsView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct AboutUsView: View {
    var body: some View {
        List {
            // Hospital Overview Section
            Section(header: Text("Hospital Overview")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("Our hospital was founded in 1978 with the mission to provide exceptional healthcare services to our community. We are dedicated to our patients and committed to our values of compassion, integrity, and excellence.")
            }
            
            // Services Section
            Section(header: Text("Services")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("We offer a wide range of medical services including Cardiology, Orthopedics, Pediatrics, and more. Our state-of-the-art facilities and experienced staff ensure the highest quality care.")
            }
            
            // Key Personnel Section
            Section(header: Text("Key Personnel")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("Meet our leadership team, including our CEO, Chief Medical Officer, and other key staff members dedicated to your care.")
            }
            
            // Achievements and Accreditations Section
            Section(header: Text("Achievements and Accreditations")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("Our hospital is accredited by [Accreditation Bodies] and has received numerous awards for our outstanding services and commitment to patient care.")
            }
            
            // Contact Information Section
            Section(header: Text("Contact Information")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                Text("Address: 123 Hospital Street, City, State, ZIP\nPhone: (123) 456-7890\nEmail: contact@hospital.com")
            }
            
            // Follow Us Section
            Section(header: Text("Follow Us")
                        .font(.title3)
                        .fontWeight(.semibold)) {
                HStack {
                    Link(destination: URL(string: "https://facebook.com/hospital")!) {
                        Image(systemName: "link.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Link(destination: URL(string: "https://twitter.com/hospital")!) {
                        Image(systemName: "link.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    Link(destination: URL(string: "https://instagram.com/hospital")!) {
                        Image(systemName: "link.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.top, 10)
            }
        }
        .navigationTitle("About Us")
    }
}

struct AboutUsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AboutUsView()
        }
    }
}


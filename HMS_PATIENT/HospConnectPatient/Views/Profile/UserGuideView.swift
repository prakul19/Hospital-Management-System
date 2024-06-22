//
//  UserGuideView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct UserGuideView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Getting Started")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Learn how to create an account, log in, and set up your profile.")
                
                Text("Booking Appointments")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Step-by-step guide on how to book, reschedule, and cancel appointments.")
                
                Text("Viewing Medical Records")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Instructions on how to access and interpret your medical records.")
                
                Text("Managing Notifications")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("Learn how to manage and customize your notification settings.")
            }
            .padding()
        }
        .navigationTitle("User Guide")
    }
}

struct UserGuideView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserGuideView()
        }
    }
}


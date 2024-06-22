//
//  TroubleshootingView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct TroubleshootingView: View {
    var body: some View {
        List {
            Section(header: Text("Login Issues")) {
                Text("Problem: Unable to log in\nSolution: Ensure you are using the correct username and password. If you forgot your password, use the 'Forgot Password' link to reset it.")
            }
            Section(header: Text("App Crashes")) {
                Text("Problem: App crashes on startup\nSolution: Try restarting your device. If the problem persists, reinstall the app from the App Store.")
            }
        }
        .navigationTitle("Troubleshooting Tips")
    }
}

struct TroubleshootingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TroubleshootingView()
        }
    }
}


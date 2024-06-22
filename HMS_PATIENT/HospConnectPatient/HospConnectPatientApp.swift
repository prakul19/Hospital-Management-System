//
//  HospConnectPatientApp.swift
//  HospConnectPatient
//
//  Created by Harsh Goyal on 05/06/24.
//

import SwiftUI

@main
struct HospConnectPatientApp: App {
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false
    @StateObject private var viewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                ContentView()
                    .environmentObject(viewModel)
                        } else {
                            WelcomeScreen()
                        }
        }
    }
}

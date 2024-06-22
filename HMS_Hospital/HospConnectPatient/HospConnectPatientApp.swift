//
//  HospConnectPatientApp.swift
//  HospConnectPatient
//
//  Created by Harsh Goyal on 05/06/24.
//

import SwiftUI

@main
struct HospConnectPatientApp: App {
    @StateObject var viewModel : AuthViewModel = AuthViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

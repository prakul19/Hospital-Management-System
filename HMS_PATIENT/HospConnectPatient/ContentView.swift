//
//  ContentView.swift
//  HospConnectPatient
//
//  Created by Harsh Goyal on 05/06/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        
        Group {
            if viewModel.currentUserToken == nil {
                LoginView()
            }
            else{
                MainTabView()
            }
        }
        
    }
}

#Preview {
    ContentView().environmentObject(AuthViewModel())
}

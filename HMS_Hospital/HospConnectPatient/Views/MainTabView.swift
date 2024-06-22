//
//  MainTabView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
            Text("Second")
                .tabItem { Label("Check-ups", systemImage: "stethoscope") }
            Text("Third")
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    MainTabView()
}

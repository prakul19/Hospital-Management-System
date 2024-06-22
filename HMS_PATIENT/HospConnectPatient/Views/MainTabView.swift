//
//  MainTabView.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "doc.text.image")
                }
            CheckUpsView()
                .tabItem {
                    Label("Check-ups", systemImage: "stethoscope")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.green)
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
#endif


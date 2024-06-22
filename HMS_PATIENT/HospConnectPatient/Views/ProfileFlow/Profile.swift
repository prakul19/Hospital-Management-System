//
//  Profile.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct ProfileView2: View {
    // MARK: - Environment
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    // MARK: - State
    
    @State private var showingLogoutAlert = false
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                profileHeader
                
                // Menu List
                menuList
            }
            .navigationTitle("Profile")
            .navigationBarHidden(false)
            .alert(isPresented: $showingLogoutAlert) {
                Alert(
                    title: Text("Log Out"),
                    message: Text("Are you sure you want to log out?"),
                    primaryButton: .default(Text("Yes")) {
                        viewModel.deleteToken()
                        // Navigate to a different screen if needed
                    },
                    secondaryButton: .cancel(Text("No"))
                )
            }
        }
    }
    
    // MARK: - Subviews
    
    private var profileHeader: some View {
        ZStack(alignment: .top) {
            Color(UIColor.systemGroupedBackground)
                .frame(height: 150)
            
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
                .offset(y: 40) // Adjust the vertical position of the image
        }
    }
    
    private var menuList: some View {
        List {
            Section {
                NavigationLink(destination: Text("Edit Profile")) {
                    Text("Edit Profile")
                }
                NavigationLink(destination: Text("Notifications")) {
                    Text("Notifications")
                }
                NavigationLink(destination: Text("Health Details")) {
                    Text("Health Details")
                }
            }
            
            Section {
                NavigationLink(destination: Text("My Prescriptions")) {
                    Text("My Prescriptions")
                }
                NavigationLink(destination: AboutUsView2()) {
                    Text("About us")
                }
                NavigationLink(destination: Text("Help Centre")) {
                    Text("Help Centre")
                }
            }
            
            // Logout Button
            Button(action: {
                showingLogoutAlert = true
            }) {
                HStack {
                    Spacer()
                    Text("Log out")
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .background(Color.red)
                .cornerRadius(10)
            }
            .listRowInsets(EdgeInsets())
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct ProfileView_Previews2: PreviewProvider {
    static var previews: some View {
        ProfileView2()
            .environmentObject(AuthViewModel())
    }
}



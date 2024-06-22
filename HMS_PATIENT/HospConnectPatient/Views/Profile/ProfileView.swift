//
//  ProfileView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingLogoutAlert = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var profileImage: UIImage?

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 25)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 25)
                    }
                    
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                    
                    List {
                        Section() {
                            NavigationLink(destination: EditProfileView(firstName: $firstName, lastName: $lastName, profileImage: $profileImage)) {
                                Text("Edit Profile")
                                    .foregroundColor(.black)
                            }
                            NavigationLink(destination: AboutUsView()) {
                                Text("About Us")
                                    .foregroundColor(.black)
                            }
                            NavigationLink(destination: HelpCenterView()) {
                                Text("Help Center")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        Text("Log out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                }
            }
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
        .onAppear {
            fetchProfileData()
        }
    }

    private func fetchProfileData() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/patients/user/profile") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let profileResponse = try decoder.decode(ProfileResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.firstName = profileResponse.user.firstName
                    self.lastName = profileResponse.user.lastName
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

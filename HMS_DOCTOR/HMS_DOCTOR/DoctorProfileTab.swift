
import SwiftUI

struct ProfileView: View {
    @Binding var isLoggedIn: Bool
    @Binding var doctorId: String
    @Binding var password: String
    @EnvironmentObject var viewModel: AppViewModel
    @StateObject private var profileViewModel = DoctorProfileViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Spacer().frame(height: 40)
                
                // Profile Image
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Spacer().frame(height: 10)
                
                // Profile Name
                if let doctor = profileViewModel.doctor {
                    Text("\(doctor.firstName) \(doctor.lastName)")
                        .font(.title)
                        .fontWeight(.bold)
                } else if profileViewModel.isLoading {
                    ProgressView()
                } else if let error = profileViewModel.error {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                } else {
                    Text("Doctor Name")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                Spacer().frame(height: 30)
                
                // Group 1: Edit Profile, About Us, and Help Center
                VStack(spacing: 0) {
                    NavigationLink(destination: DoctorProfileView(viewModel: profileViewModel)) {
                        HStack {
                            Text("Profile")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white)
                    }
                    Divider()
                    NavigationLink(destination: AboutUsView()) {
                        HStack {
                            Text("About Us")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white)
                    }
                    Divider()
                    NavigationLink(destination: HelpCenterView()) {
                        HStack {
                            Text("Help Center")
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
                .cornerRadius(10)
                .shadow(radius: 1)
                .padding(.horizontal, 20)
                .foregroundColor(.black)
                               
                Spacer()
                               
                // Log Out Button
                Button(action: {
                    isLoggedIn = false
                    doctorId = ""
                    password = ""
                    viewModel.signOut()
                }) {
                    Text("Log out")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
                Spacer().frame(height: 20)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("")
            .navigationBarHidden(true)
            .onAppear {
                profileViewModel.fetchProfile()
            }
        }
    }
}

// Dummy views for navigation links
struct AboutUsView: View {
    var body: some View {
        Text("About Us")
    }
}

struct HelpCenterView: View {
    var body: some View {
        Text("Help Center")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true), doctorId: .constant(""), password: .constant("")).environmentObject(AppViewModel())
    }
}

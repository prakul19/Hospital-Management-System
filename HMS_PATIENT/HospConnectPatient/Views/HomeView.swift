//
//  HomeView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI
import StreamVideo
import StreamVideoSwiftUI
struct HomeView: View {
    // MARK: - Properties
    
    @EnvironmentObject var viewModel: AuthViewModel
    @StateObject var specializationViewModel = SpecializationViewModel()
    @State private var isLoading = true
    @State private var showNoNotifications = false // Step 1: State variable to track notifications
    @State private var showVideoCall = false // State variable to present VideoCallApp
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // MARK: Today Section
                        HStack {
                            Text("Today")
                                .font(.largeTitle)
                                .bold()
                            
                            Text(currentDate())
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.top)
                            
                            Spacer()
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    // Action for SOS button
                                    showVideoCall = true
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 30, height: 30)
                                        Text("SOS")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                    }
                                }
                                Button(action: {
                                    showNoNotifications = true
                                }) {
                                    Image(systemName: "bell")
                                        .foregroundColor(.gray)
                                        .frame(width: 30, height: 10)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: Search Bar
                        SearchBar()
                            .padding(.horizontal)
                        
                        // MARK: Appointments Section
                        Text("Appointments")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top, 20)
                        
                        HStack(spacing: 16) {
                            NavigationLink(destination: ClinicView()) {
                                ServiceButton(title: "Clinic Visit", subtitle: "Make an appointment", color: .green, iconName: "plus.circle.fill")
                                    .frame(width: 180, height: 130)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: VideoChat()) {
                                ServiceButton(title: "Video Chat", subtitle: "Video Call with doctor", color: .gray.opacity(0.4), iconName: "video.circle.fill")
                                    .frame(width: 180, height: 130)
                            }
                        }
                        .padding(.horizontal)
                        
                        // MARK: Featured Services Section
                        Text("Featured Services")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        FeaturedServicesGrid()
                            .padding(.horizontal)
                            .padding(.top, 1)
                        
                        // MARK: Articles Section
                        Text("Articles")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        BestOffersView()
                            .padding(.horizontal)
                    }
                }
                .padding(.all, 2)
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5, anchor: .center)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
            .onAppear {
                fetchData()
            }
            .navigationBarHidden(true)
        }
        .alert(isPresented: $showNoNotifications) {
            Alert(
                title: Text("No new Notifications right now")
            )
        } // Step 3: Display the text based on state variable
        .fullScreenCover(isPresented: $showVideoCall) {
            VideoCallApps() // Use the proper initializer if needed
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchData() {
        // Simulate network request by delaying the loading state update
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter.string(from: Date())
    }
}

// MARK: - Preview

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AuthViewModel())
    }
}
#endif

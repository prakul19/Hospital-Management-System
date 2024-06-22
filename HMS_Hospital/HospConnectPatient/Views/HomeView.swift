//
//  HomeView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingAlert = false
    @State private var isLoading = true // Initially set to true
    @State private var dataLoaded = false // Flag to track if data is loaded
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Today")
                            .font(.largeTitle)
                            .bold()
                        
                        Text("23 May")
                            .foregroundColor(.gray)
                            .font(.title)
                            .bold()
                        
                        Spacer()
                    }
                    .padding(.bottom, 8)
                    
                    Text("Dashboard")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                        .padding(.bottom, 16)
                    
                    if isLoading {
                        // Loader only appears when isLoading is true
                        GeometryReader { geometry in
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: geometry.size.width / 2,
                                       height: geometry.size.width / 2)
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 10) {
                            DashboardItem(title: "Treatments", destination: TreatmentView())
                            DashboardItem(title: "My Doctors", destination: DoctorView())
                            DashboardItem(title: "My Patients", destination: PatientListView())
                            DashboardItem(title: "Bed Availability", destination: BedAvailabilityView())
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        showingAlert = true
                    }) {
                        Text("Sign out")
                            .frame(maxWidth:.infinity)
                            .frame(height:50)
                            .background(.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .navigationTitle("")
                .navigationBarHidden(true)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Sign Out"), message: Text("Are you sure you want to sign out?"), primaryButton: .default(Text("Yes")) {
                        viewModel.signOutUser()
                    }, secondaryButton: .cancel())
                }
            }
            .onAppear {
                // Start loading data only if it hasn't been loaded before
                if !dataLoaded {
                    fetchData {
                        // Once data is fetched, stop loading and set dataLoaded flag
                        isLoading = false
                        dataLoaded = true
                    }
                }
            }
        }
    }
    
    // Simulated data fetching function
    func fetchData(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Simulate delay for data fetching
            completion()
        }
    }
}

struct DashboardItem<Destination: View>: View {
    var title: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.green)
                    .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
         
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AuthViewModel())
    }
}
#endif

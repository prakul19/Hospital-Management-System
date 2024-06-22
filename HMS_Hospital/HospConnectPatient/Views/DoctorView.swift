//
//  Doctor.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

// Define the root response struct
struct DoctorResponse: Decodable {
    let success: Bool
    let count: Int
    let doctors: [Doctor]
}

// Define the Doctor struct
struct Doctor: Decodable, Identifiable {
    var id: String { _id } // Conforming to Identifiable protocol
    let _id: String
    let firstName: String
    let lastName: String
    let dob: String
    let gender: String
    let email: String
    let phone: String
    let state: String
    let city: String
    let pincode: String
    let address: String
    let experience: Int
    let specialization: Specialization1 // Assuming specialization is nested within Doctor
    let availability: [String]
    let doctorID: String
    let __v: Int
}

// Define the Specialization struct
struct Specialization1: Decodable {
    let _id: String
    let specializationName: String
    let commonNames: String
    let doctorIDs: [String]
    let __v: Int
    let imageUrl: String
}

struct DoctorView: View {
    @State private var doctors = [Doctor]()
    @State private var categorizedDoctors = [String: [Doctor]]()
    @State private var searchText = ""
    @State private var showingProfile = false
    @State private var isLoading = false // Add loading state variable

    private var filteredDoctors: [Doctor] {
        if searchText.isEmpty {
            return doctors
        } else {
            return doctors.filter { $0.firstName.lowercased().contains(searchText.lowercased()) || $0.lastName.lowercased().contains(searchText.lowercased()) }
        }
    }

    // Fetch data from the API
    func fetchData() {
        isLoading = true // Set loading state to true when fetching data
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor") else {
            print("Invalid URL")
            isLoading = false // Set loading state to false on failure
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoading = false // Set loading state to false when data fetching is complete
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Decode JSON data into DoctorResponse object
            do {
                let decodedData = try JSONDecoder().decode(DoctorResponse.self, from: data)
                DispatchQueue.main.async {
                    self.doctors = decodedData.doctors
                    self.categorizeDoctors()
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Categorize doctors by specialization
    func categorizeDoctors() {
        var categorized = [String: [Doctor]]()
        for doctor in doctors {
            let specialization = doctor.specialization.specializationName
            if categorized[specialization] != nil {
                categorized[specialization]?.append(doctor)
            } else {
                categorized[specialization] = [doctor]
            }
        }
        self.categorizedDoctors = categorized
    }

    var body: some View {
        NavigationView {
            VStack {
                // Loading view
                if isLoading {
                    ProgressView()
                } else {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color.gray.opacity(0.2))
                                .frame(height: 40)
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                                TextField("Search Doctors", text: $searchText)
                            }
                        }
                        .padding([.leading, .trailing, .bottom], 10) // Padding from the sides
                    }
                    .padding(.top)
                    
                    List {
                        ForEach(categorizedDoctors.keys.sorted(), id: \.self) { specialization in
                            Section(header: Text("\(specialization) Doctors")) {
                                ForEach(filteredDoctors.filter { $0.specialization.specializationName == specialization }, id: \.id) { doctor in
                                    DoctorRow(doctor: doctor)
                                }
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                AddDoctorView()
            }
            .onAppear(perform: fetchData)
        }
        .navigationBarTitle("My Doctors", displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button(action: {
                    showingProfile.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20)) // Adjust size of plus button
                        .foregroundColor(.green)
                }
        )
    }
}

struct DoctorRow: View {
    var doctor: Doctor
    @State private var showingDoctorProfile = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingDoctorProfile.toggle()
                }) {
                    Text("View")
                        .foregroundColor(.green)
                        .padding()
                }
            }
        }
        .sheet(isPresented: $showingDoctorProfile) {
            DoctorDetailView(doctor: doctor)
        }
    }
}

struct DoctorDetailView: View {
    var doctor: Doctor
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(doctor.email)
                    }
                    HStack {
                        Text("Phone")
                        Spacer()
                        Text(doctor.phone)
                    }
                }

                Section(header: Text("Professional Information")) {
                    HStack {
                        Text("Specialization")
                        Spacer()
                        Text(doctor.specialization.specializationName)
                    }
                    HStack {
                        Text("Experience")
                        Spacer()
                        Text("\(doctor.experience) years")
                    }
                }

                Section(header: Text("Other Details")) {
                    HStack {
                        Text("Age")
                        Spacer()
                        Text(calculateAge(dob: doctor.dob))
                    }
                    HStack {
                        Text("Gender")
                        Spacer()
                        Text(doctor.gender)
                    }
                    HStack {
                        Text("City")
                        Spacer()
                        Text(doctor.city)
                    }
                    HStack {
                        Text("State")
                        Spacer()
                        Text(doctor.state)
                    }
                }
            }
            .navigationBarTitle("Doctor Details", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    // Helper function to calculate age from date of birth
    func calculateAge(dob: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust based on your date format

        print("DOB string received: \(dob)")
        
        if let birthDate = dateFormatter.date(from: dob) {
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
            return "\(ageComponents.year ?? 0)"
        }
        
        print("Failed to parse DOB string")
        return "N/A"
    }
}

// Define the ContentView_Previews SwiftUI view for previewing
struct DoctorView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorView()
    }
}


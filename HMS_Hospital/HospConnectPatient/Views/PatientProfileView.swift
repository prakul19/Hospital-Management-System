//
//  PatientProfile.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct PatientDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var patient: Patient
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information").font(.headline)) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Full Name")
                                .fontWeight(.semibold)
                            Spacer()
                            Text("\(patient.firstName) \(patient.lastName)")
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Gender")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.gender)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Date of Birth")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.dob.split(separator: "T").first?.split(separator: "-").joined(separator: "/") ?? "")
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Email")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.email)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Verified")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.isVerified ? "Yes" : "No")
                        }
                    }
                }
                
                Section(header: Text("Contact Information").font(.headline)) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Contact")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.contact)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Address")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.address)
                        }
                    }
                }
                
                Section(header: Text("Health Information").font(.headline)) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Blood Group")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.bloodGroup)
                        }
                    }
                    if let height = patient.height {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Height")
                                    .fontWeight(.semibold)
                                Spacer()
                                Text("\(height)")
                            }
                        }
                    }
                    if let weight = patient.weight {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Weight")
                                    .fontWeight(.semibold)
                                Text("\(weight)")
                                Spacer()
                            }
                        }
                    }
                }
                
                Section(header: Text("Additional Information").font(.headline)) {
                    NavigationLink(destination: AppointmentsListView(patientID: patient.id, authViewModel: AuthViewModel())) {
                        VStack(alignment: .leading, spacing: 8) {
                                        Text("Appointments")
                                            .fontWeight(.semibold)
                                    }
                                }
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Patient ID")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(patient.patientId)
                        }
                    }
                }
            }
            .navigationBarTitle("Patients Details", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    struct AppointmentsListView: View {
        var patientID: String
        @StateObject var authViewModel: AuthViewModel
        @State private var appointments: [Appointment] = []
        @State private var isLoading = false
        @State private var errorMessage: String?
        
        var body: some View {
            VStack {
                if isLoading {
                    ProgressView()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                } else {
                    List(appointments) { appointment in
                        Section {
                            HStack {
                                Text("Date:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.date.split(separator: "T").first?.split(separator: "-").joined(separator: "/") ?? "")")
                            }
                            HStack {
                                Text("Meet Type:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.meetType)")
                            }
                            HStack {
                                Text("Time Slot:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.timeSlot)")
                            }
                            HStack {
                                Text("Symptoms:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.symptoms)")
                            }
                            HStack {
                                Text("Status:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.status)")
                            }
                            HStack {
                                Text("Doctor ID:")
                                    .bold()
                                Spacer()
                                Text("\(appointment.id)")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Appointments")
            .onAppear {
                fetchAppointments()
            }
        }

        
        func fetchAppointments() {
            isLoading = true
            HospConnectPatient.fetchAppointments(forPatientID: patientID, with: authViewModel) { result in
                switch result {
                case .success(let fetchedAppointments):
                    DispatchQueue.main.async {
                        self.appointments = fetchedAppointments
                        isLoading = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        errorMessage = "Error: \(error.localizedDescription)"
                        isLoading = false
                    }
                }
            }
        }
    }


    struct PatientDetailView_Previews: PreviewProvider {
        static var previews: some View {
            PatientDetailView(patient: Patient(id: "1", firstName: "John", lastName: "Doe", gender: "Male", dob: "1990-01-01", email: "john@example.com", isVerified: true, profileImage: "", contact: "", bloodGroup: "", address: "", height: nil, weight: nil, role: "", otp: "", ailments: [], symptoms: [], appointments: [], patientId: "", version: 0))
        }
    }
}



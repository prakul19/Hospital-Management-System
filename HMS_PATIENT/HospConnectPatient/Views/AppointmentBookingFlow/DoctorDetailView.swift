//
//  DoctorDetailView.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import SwiftUI

struct DoctorDetailsView: View {
    // MARK: - Properties
    
    @StateObject private var viewModel = DoctorViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let doctor: Doctor
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 5) {
                    // Doctor Info Section
                    VStack(spacing: 10) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                            .clipShape(Circle())
                        
                        Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(doctor.specialization.specializationName)
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("\(doctor.experience) years of experience")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Divider
                    Divider()
                    
                    // Doctor Details Section
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Email:")
                                .font(.headline)
                            Spacer()
                            Text(doctor.email)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Phone:")
                                .font(.headline)
                            Spacer()
                            Text(doctor.phone)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Address:")
                                .font(.headline)
                            Spacer()
                            Text(doctor.address)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    // About Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("About Dr. \(doctor.firstName) \(doctor.lastName)")
                            .font(.headline)
                        
                        Text("Dr. \(doctor.firstName) \(doctor.lastName) is a highly experienced \(doctor.specialization.specializationName) with over \(doctor.experience) years in the field. He/She is dedicated to providing top-notch care and expertise to his/her patients.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .padding(.horizontal)
                    
                    // Book Appointment Button
                    NavigationLink(destination: ConsultationOptionsView(doctor: doctor)) { // Pass doctor info
                        Text("Book Appointment")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                    .padding(.top, 30)
                    .padding(.horizontal)
                }
                .padding()
                .offset(y: -50)
            }
            .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Doctor Details")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

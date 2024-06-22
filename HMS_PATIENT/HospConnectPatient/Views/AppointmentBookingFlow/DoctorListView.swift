//
//  DoctorListView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

// MARK: - Doctor List View

struct DoctorListView: View {
    @StateObject private var viewModel = DoctorViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    let specializationId: String
    let commonNames: String


    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.doctors) { doctor in
                        NavigationLink(destination: DoctorDetailsView(doctor: doctor)) {
                            HStack(spacing: 0) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .padding(.trailing, 10)

                                VStack(alignment: .leading) {
                                    Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                                        .font(.headline)
                                        .fontWeight(.bold)

                                    Text(doctor.specialization.specializationName)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text("\(doctor.experience) years of experience")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                .onAppear {
                    viewModel.fetchDoctors(for: specializationId)
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text(commonNames)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                }
            }
            .navigationViewStyle(.stack)
        }
        .navigationBarBackButtonHidden(true)
    }
}

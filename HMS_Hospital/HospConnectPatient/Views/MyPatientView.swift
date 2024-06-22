//
//  MypatientView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct PatientListView: View {
    @ObservedObject var viewModel = PatientViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchText: $searchText)

                List(viewModel.patients.filter {
                    searchText.isEmpty ? true :
                        $0.firstName.localizedCaseInsensitiveContains(searchText) ||
                        $0.lastName.localizedCaseInsensitiveContains(searchText)
                }) { patient in
                    NavigationLink(destination: PatientDetailView(patient: patient)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(patient.firstName) \(patient.lastName)")
                                .font(.headline)
                            Text(patient.email)
                                .font(.subheadline)
                            Text("Gender: \(patient.gender)")
                                .font(.subheadline)
                            Text("DOB: \(patient.dob.split(separator: "T").first?.split(separator: "-").joined(separator: "/") ?? "")")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationBarTitle("Patients", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.green)
                            .bold()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
}


struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 5)

            if !searchText.isEmpty { // Show clear button only when there is text
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10) // Adjusted trailing padding
                }
            }
        }
        .padding()
    }
}

struct PatientListView_Previews: PreviewProvider {
    static var previews: some View {
        PatientListView()
    }
}

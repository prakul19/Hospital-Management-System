//
//  AddBedsModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI

struct AddBedSheet: View {
    @Binding var showAddBedSheet: Bool
    @State private var bedNumber: String = ""
    @State private var status: String = "Choose"
    @State private var selectedSpecialization: Specialization?
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @ObservedObject var viewModel = SpecializationViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Bed Details")) {
                    TextField("Bed Number", text: $bedNumber)
                        .onChange(of: bedNumber) { newValue in
                            print("Bed number changed: \(newValue)")
                        }
                    
                    Picker("Status", selection: $status) {
                        Text("Choose")
                        Text("Available").tag("available")
                        Text("Occupied").tag("occupied")
                    }
                    .pickerStyle(.menu)
                    
                    if let specializations = viewModel.services["Specializations"] {
                        Picker("Specialization", selection: $selectedSpecialization) {
                            Text("Select specialization").tag(nil as Specialization?)
                            ForEach(specializations) { specialization in
                                Text(specialization.commonNames).tag(specialization as Specialization?)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedSpecialization) { newValue in
                            print("Selected specialization changed: \(newValue?.commonNames ?? "nil")")
                        }
                    } else {
                        Text("Fetching specializations...")
                            .foregroundColor(.gray)
                    }
                }

                if isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle("Add Bed", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    showAddBedSheet = false
                },
                trailing: Button("Done") {
                    addBed()
                }.disabled(isLoading || bedNumber.isEmpty || selectedSpecialization == nil || selectedSpecialization?.id.isEmpty ?? true)
            )
            .onAppear {
                viewModel.fetchSpecializations()
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Message"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                    // Dismiss the sheet when the user clicks OK
                    showAddBedSheet = false
                })
            }
        }
    }

    @MainActor func addBed() {
        guard let token = AuthViewModel().currentUserToken else {
            print("Token is not available")
            return
        }
        
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/hospitalAdmin/beds/register") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let newBed = [
            "bedNumber": bedNumber,
            "status": status,
            "specializationID": selectedSpecialization?.id ?? ""
        ]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: newBed) else {
            print("Failed to serialize JSON")
            return
        }

        request.httpBody = httpBody

        isLoading = true
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
            }

            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = error?.localizedDescription ?? "Unknown error"
                    self.showErrorAlert = true
                }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(AddBedResponse.self, from: data)
                if decodedResponse.success {
                    DispatchQueue.main.async {
                        // Show simplified alert message for successful addition
                        self.errorMessage = "Bed added successfully"
                        self.showErrorAlert = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to add bed"
                        self.showErrorAlert = true
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error decoding response: \(error)"
                    self.showErrorAlert = true
                }
            }
        }.resume()
    }
}

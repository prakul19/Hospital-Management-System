//
//  AddDoctorView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI
import Combine

struct AddDoctorView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var doctor = DoctorData()
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var isLoading = false
    @ObservedObject var viewModel = SpecializationViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $doctor.firstName)
                    TextField("Last Name", text: $doctor.lastName)
                    DatePicker("Date of Birth", selection: $doctor.dob, in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!, displayedComponents: .date)
                    Picker("Gender", selection: $doctor.gender) {
                        Text("Not selected").tag("")
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                }
                
                Section(header: Text("Contact Information")) {
                    TextField("Email", text: $doctor.email)
                        .keyboardType(.emailAddress)
                    TextField("Phone Number", text: $doctor.phone)
                        .keyboardType(.numberPad)
                        .onReceive(Just(doctor.phone)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.doctor.phone = filtered
                            }
                            if newValue.count > 10 {
                                self.doctor.phone = String(newValue.prefix(10))
                            }
                        }
                }
                
                Section(header: Text("Location Information")) {
                    TextField("State", text: $doctor.state)
                    TextField("City", text: $doctor.city)
                    TextField("Pincode", text: $doctor.pincode)
                        .keyboardType(.numberPad)
                        .onReceive(Just(doctor.pincode)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.doctor.pincode = filtered
                            }
                            if newValue.count > 6 {
                                self.doctor.pincode = String(newValue.prefix(6))
                            }
                        }
                    TextField("Address", text: $doctor.address)
                }
                
                Section(header: Text("Professional Information")) {
                    Picker("Speciality", selection: $doctor.specialization) {
                        Text("Not selected").tag("")
                        ForEach(viewModel.services["Specializations"] ?? [], id: \.id) { specialization in
                            Text(specialization.commonNames).tag(specialization.id)
                        }
                    }
                    TextField("Medical License", text: $doctor.medicalLicense)
                        .keyboardType(.numberPad)
                        .onReceive(Just(doctor.medicalLicense)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.doctor.medicalLicense = filtered
                            }
                        }
                    TextField("Experience", text: $doctor.experience)
                        .keyboardType(.numberPad)
                        .onReceive(Just(doctor.experience)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.doctor.experience = filtered
                            }
                            if newValue.count > 2 {
                                self.doctor.experience = String(newValue.prefix(2))
                            }
                        }
                    TextField("Education Details", text: $doctor.educationDetails)
                    TextField("Certifications", text: $doctor.certifications)
                }
            }
            .navigationBarTitle("New Doctor Details", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    if isFormValid() {
                        isLoading = true
                        addDoctor()
                    } else {
                        showAlert = true
                        alertTitle = "Validation Error"
                        alertMessage = validationErrorMessage()
                    }
                }
                    .disabled(isLoading)
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .overlay(
                            isLoading ? ProgressView() : nil // Show loader if isLoading is true
                        )
            .disabled(isLoading)
            .onAppear {
                viewModel.fetchSpecializations()
            }
        }
    }

    func isFormValid() -> Bool {
        !doctor.firstName.isEmpty &&
        !doctor.lastName.isEmpty &&
        doctor.gender != "" &&
        !doctor.email.isEmpty &&
        isValidEmail(doctor.email) &&
        doctor.phone.count == 10 &&
        !doctor.state.isEmpty &&
        !doctor.city.isEmpty &&
        doctor.pincode.count == 6 &&
        !doctor.address.isEmpty &&
        doctor.specialization != "" &&
        !doctor.medicalLicense.isEmpty &&
        doctor.experience.count <= 2 &&
        !doctor.experience.isEmpty &&
        !doctor.educationDetails.isEmpty &&
        !doctor.certifications.isEmpty &&
        Calendar.current.dateComponents([.year], from: doctor.dob, to: Date()).year! >= 18
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func validationErrorMessage() -> String {
        if doctor.firstName.isEmpty {
            return "First Name is required."
        }
        if doctor.lastName.isEmpty {
            return "Last Name is required."
        }
        if doctor.gender.isEmpty {
            return "Gender is required."
        }
        if doctor.email.isEmpty || !isValidEmail(doctor.email) {
            return "Valid Email is required."
        }
        if doctor.phone.count != 10 {
            return "Phone Number must be 10 digits."
        }
        if doctor.state.isEmpty {
            return "State is required."
        }
        if doctor.city.isEmpty {
            return "City is required."
        }
        if doctor.pincode.count != 6 {
            return "Pincode must be 6 digits."
        }
        if doctor.address.isEmpty {
            return "Address is required."
        }
        if doctor.specialization.isEmpty {
            return "Specialization is required."
        }
        if doctor.medicalLicense.isEmpty {
            return "Medical License is required."
        }
        if doctor.experience.isEmpty || doctor.experience.count > 2 {
            return "Experience must be a valid number up to 2 digits."
        }
        if doctor.educationDetails.isEmpty {
            return "Education Details are required."
        }
        if doctor.certifications.isEmpty {
            return "Certifications are required."
        }
        if Calendar.current.dateComponents([.year], from: doctor.dob, to: Date()).year! < 18 {
            return "Doctor must be at least 18 years old."
        }
        return "Please fill in all required fields correctly."
    }

    func addDoctor() {
        print("addDoctor() called")
        
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/register") else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Invalid URL"
            print(alertMessage)
            return
        }
        
        print("URL is valid: \(url)")
        
        guard let jsonData = try? JSONEncoder().encode(doctor) else {
            showAlert = true
            alertTitle = "Error"
            alertMessage = "Failed to encode data"
            print(alertMessage)
            return
        }
        
        print("Doctor data encoded successfully")
        print("Encoded JSON: \(String(data: jsonData, encoding: .utf8) ?? "")")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NTk1YzJjZTlkY2JiNzhkMTY2YTJmZiIsImlhdCI6MTcxNzE0NzkxOCwiZXhwIjoxNzE5NzM5OTE4fQ.aCUZP7b5qohZQcOohajST-GfqqWtjYRVNK8jyYlmPuk", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        print("Starting network request...")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    showAlert = true
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    print(alertMessage)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
                if (200..<300).contains(response.statusCode) {
                    // Successful response
                    DispatchQueue.main.async {
                        showAlert = true
                        alertTitle = "Success"
                        alertMessage = "Doctor added successfully"
                        print(alertMessage)
                        presentationMode.wrappedValue.dismiss()
                    }
                } else {
                    DispatchQueue.main.async {
                        showAlert = true
                        alertTitle = "Error"
                        alertMessage = "Failed to add doctor"
                        print(alertMessage)
                    }
                }
            }
            
            if let data = data {
                print("Response data: \(String(data: data, encoding: .utf8) ?? "")")
            }
        }.resume()
    }
}

struct AddDoctorProfile_Previews: PreviewProvider {
    static var previews: some View {
        AddDoctorView()
    }
}

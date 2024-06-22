import SwiftUI

struct DoctorProfileView: View {
    @ObservedObject var viewModel: DoctorProfileViewModel

    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: String = ""
    @State private var gender: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let doctor = viewModel.doctor {
                VStack {
                    
                    // Profile Image
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                    
                    Spacer().frame(height: 10)
                    
                    
                    Spacer().frame(height: 20)
                    
                    // Profile Details Form
                    Form {
                        Section(header: Text("Personal Information")) {
                            HStack {
                                Text("First Name")
                                Spacer()
                                TextField("First Name", text: $firstName)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Last Name")
                                Spacer()
                                TextField("Last Name", text: $lastName)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Date of Birth")
                                Spacer()
                                TextField("Date of Birth", text: $dob)
                                    .multilineTextAlignment(.trailing)
                                    .onChange(of: dob) { newValue in
                                        if newValue.count > 10 {
                                            dob = String(newValue.prefix(10))
                                        }
                                    }
                            }
                            HStack {
                                Text("Gender")
                                Spacer()
                                TextField("Gender", text: $gender)
                                    .multilineTextAlignment(.trailing)
                            }
                        }

                        Section(header: Text("Contact Information")) {
                            HStack {
                                Text("Email")
                                Spacer()
                                TextField("Email", text: $email)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Contact Number")
                                Spacer()
                                TextField("Contact Number", text: $phone)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Text("Address")
                                Spacer()
                                TextField("Address", text: $address)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    .onAppear {
                        // Set the initial values
                        self.firstName = doctor.firstName
                        self.lastName = doctor.lastName
                        self.dob = formatDateString(doctor.dob)
                        self.gender = doctor.gender
                        self.email = doctor.email
                        self.phone = doctor.phone
                        self.address = doctor.address
                    }
                }
                .padding()
            } else if let error = viewModel.error {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            viewModel.fetchProfile()
        }
    }
    
    private func formatDateString(_ dateString: String) -> String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withFullDate]
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd"
            return outputFormatter.string(from: date)
        } else {
            return dateString.prefix(10).description // Fallback if the date parsing fails
        }
    }
}

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorProfileView(viewModel: DoctorProfileViewModel())
    }
}


//
//  EditProfileView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import SwiftUI
import Combine

struct EditProfileView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var profileImage: UIImage?
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isImagePickerPresented = false
    @State private var dateOfBirth: Date = Date()
    @State private var gender: String = "Not selected"
    @State private var email: String = ""
    @State private var isEmailValid: Bool = true
    @State private var contactNumber: String = ""
    @State private var bloodGroup: String = "Not selected"
    @State private var address: String = ""

    @ObservedObject var authViewModel = AuthViewModel()

    let genders = ["Not selected", "Male", "Female", "Others"]
    let bloodGroups = ["Not selected", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]

    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)

                VStack(spacing: 20) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 25)
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundColor(.black)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .padding(.top, 25)
                    }

                    Button("Edit") {
                        isImagePickerPresented = true
                    }
                    .foregroundColor(.blue)
                    .sheet(isPresented: $isImagePickerPresented) {
                       ImagePicker(image: $profileImage)
                    }

                    List {
                        Section {
                            HStack {
                                Text("First Name")
                                Spacer()
                                TextField("First Name", text: $firstName)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }

                            HStack {
                                Text("Last Name")
                                Spacer()
                                TextField("Last Name", text: $lastName)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }

                            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)

                            Picker("Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { gender in
                                    Text(gender)
                                }
                            }

                            HStack {
                                Text("Email")
                                Spacer()
                                TextField("Email", text: $email)
                                    .autocapitalization(.none)
                                    .keyboardType(.emailAddress)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                            if !isEmailValid {
                                Text("Invalid email address")
                                    .foregroundColor(.red)
                                    .font(.footnote)
                            }

                            HStack {
                                Text("Contact Number")
                                Spacer()
                                TextField("Contact Number", text: $contactNumber)
                                    .keyboardType(.numberPad)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                                    .onReceive(Just(contactNumber)) { newValue in
                                        let filtered = newValue.filter { "0123456789".contains($0) }
                                        if filtered != newValue {
                                            self.contactNumber = filtered
                                        }
                                        if self.contactNumber.count > 10 {
                                            self.contactNumber = String(self.contactNumber.prefix(10))
                                        }
                                    }
                            }

                            Picker("Blood Group", selection: $bloodGroup) {
                                ForEach(bloodGroups, id: \.self) { bloodGroup in
                                    Text(bloodGroup)
                                }
                            }

                            HStack {
                                Text("Address")
                                Spacer()
                                TextField("Address", text: $address)
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarItems(trailing: Button("Done") {
            isLoading = true // Show loader when the request starts
            
            // Prepare the updated profile data to send to the API
            let updatedProfileData: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "gender": gender,
                "dob": dateOfBirth.iso8601FullString,
                "email": email,
                "contact": contactNumber,
                "bloodGroup": bloodGroup,
                "address": address
            ]

            // Convert the data to JSON
            guard let jsonData = try? JSONSerialization.data(withJSONObject: updatedProfileData) else {
                print("Failed to convert data to JSON")
                isLoading = false // Hide loader if there's an error
                return
            }

            // Prepare the URL
            guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/patients/user/profile") else {
                print("Invalid URL")
                isLoading = false // Hide loader if there's an error
                return
            }

            // Prepare the request
            var request = URLRequest(url: url)
            request.httpMethod = "PUT" // Use PUT method for updating profile
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            // Add the authorization token to the request header
            guard let token = authViewModel.currentUserToken else {
                print("No token available")
                isLoading = false // Hide loader if there's an error
                return
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData // Set the JSON data as the request body

            // Send the request
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Handle response
                // You can add error handling and response parsing here
                DispatchQueue.main.async {
                    isLoading = false // Hide loader when the response is received
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                        return
                    }
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print("Status code: \(httpResponse.statusCode)")
                        
                        // Debugging statement to print the response data
                        if let responseData = data {
                            print("Response data: \(String(data: responseData, encoding: .utf8) ?? "No response data")")
                        }
                        
                        // You can handle success or failure based on the status code
                        if httpResponse.statusCode == 200 {
                            print("Request successful: Data updated")
                            showAlert = true // Show alert when data is successfully updated
                            alertMessage = "Data updated successfully"
                        } else {
                            print("Request failed: \(httpResponse.statusCode)")
                            showAlert = true // Show alert when request fails
                            alertMessage = "Failed to update data. Please try again later."
                        }
                    }
                }
            }.resume()
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding()
                }
            }
        )


        .onAppear {
            fetchProfileData()
        }
    }

    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }

    func fetchProfileData() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/patients/user/profile") else {
            print("Invalid URL")
            return
        }

        guard let token = authViewModel.currentUserToken else {
            print("No token available")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching profile data: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Print the raw JSON response for debugging
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON response: \(jsonString)")
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(ProfileResponse.self, from: data)
                if response.success {
                    DispatchQueue.main.async {
                        self.firstName = response.user.firstName
                        self.lastName = response.user.lastName
                        self.gender = response.user.gender
                        self.dateOfBirth = response.user.dob
                        self.email = response.user.email
                        self.contactNumber = response.user.contact ?? ""
                        self.bloodGroup = response.user.bloodGroup ?? "Not selected"
                        self.address = response.user.address ?? ""

                        if let profileImageString = response.user.profileImage,
                           let profileImageData = Data(base64Encoded: profileImageString),
                           let profileImage = UIImage(data: profileImageData) {
                            self.profileImage = profileImage
                        } else {
                            self.profileImage = nil
                        }

                        print("Profile data fetched successfully")
                    }
                } else {
                    print("Failed to fetch profile data")
                }
            } catch {
                print("Error decoding profile data: \(error.localizedDescription)")
            }
        }.resume()
    }

}

struct ProfileResponse: Codable {
    let success: Bool
    let user: UserProfile
}

struct UserProfile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let gender: String
    let dob: Date
    let email: String
    let isVerified: Bool
    let profileImage: String?
    let contact: String?
    let bloodGroup: String?
    let address: String?
    let height: Double?
    let weight: Double?
    let role: String
    let otp: String?
    let ailments: [String]
    let symptoms: [String]
    let appointments: [String]
    let patientId: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case gender
        case dob
        case email
        case isVerified
        case profileImage
        case contact
        case bloodGroup
        case address
        case height
        case weight
        case role
        case otp
        case ailments
        case symptoms
        case appointments
        case patientId
        case v = "__v"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        gender = try container.decode(String.self, forKey: .gender)
        let dobString = try container.decode(String.self, forKey: .dob)
        if let dobDate = DateFormatter.iso8601Full.date(from: dobString) {
            dob = dobDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .dob, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
        email = try container.decode(String.self, forKey: .email)
        isVerified = try container.decode(Bool.self, forKey: .isVerified)
        profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)
        contact = try container.decodeIfPresent(String.self, forKey: .contact)
        bloodGroup = try container.decodeIfPresent(String.self, forKey: .bloodGroup)
        address = try container.decodeIfPresent(String.self, forKey: .address)
        height = try container.decodeIfPresent(Double.self, forKey: .height)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        role = try container.decode(String.self, forKey: .role)
        otp = try container.decodeIfPresent(String.self, forKey: .otp)
        ailments = try container.decode([String].self, forKey: .ailments)
        symptoms = try container.decode([String].self, forKey: .symptoms)
        appointments = try container.decode([String].self, forKey: .appointments)
        patientId = try container.decode(String.self, forKey: .patientId)
        v = try container.decode(Int.self, forKey: .v)
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension Date {
    var iso8601FullString: String {
        DateFormatter.iso8601Full.string(from: self)
    }
}

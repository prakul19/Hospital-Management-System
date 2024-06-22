//
//  RegisterView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: String = ""
    @State private var dateOfBirth: Date = Date()
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingOTPVerification = false
    @State private var errorMessage = ""
    @State private var isLoading = false // Added state for loading indicator
    @EnvironmentObject var viewModel: AuthViewModel
    
    let genders = ["Not Selected", "Male", "Female", "Other"]
    
    var isEmailValid: Bool {
        return emailID.contains("@") && emailID.contains(".")
    }
    
    var isPasswordValid: Bool {
        let passwordRegex = "^(?=.*[A-Z]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    var isFormValid: Bool {
        return !firstName.isEmpty && !lastName.isEmpty && !gender.isEmpty && isEmailValid && isPasswordValid && !confirmPassword.isEmpty && password == confirmPassword
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()

                    VStack(alignment: .leading) {
                        Text("Create Account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                            .padding(.leading)
                            .padding(.bottom, 20)

                        Group {
                            HStack {
                                TextField("First Name", text: $firstName)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)

                                TextField("Last Name", text: $lastName)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }

                            HStack {
                                Text("Choose Gender")
                                    .foregroundColor(.gray)
                                    .padding()
                                
                                Spacer()
                                Picker("", selection: $gender) {
                                    ForEach(genders, id: \.self) {
                                        Text($0)
                                        .foregroundColor(.gray)
                                    }
                                    .foregroundColor(.gray)
                                }
                                .foregroundColor(.gray)
                                .pickerStyle(MenuPickerStyle())
                                .foregroundColor(.gray)
                            }
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.gray)
                            .cornerRadius(10)
                            
                            DatePicker("Date of Birth", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                                .foregroundColor(.gray)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)

                            TextField("Email ID", text: $emailID)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)

                            SecureField("Password", text: $password)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .textContentType(.oneTimeCode) // Disabling auto password generation

                            SecureField("Confirm Password", text: $confirmPassword)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .textContentType(.oneTimeCode) // Disabling auto password generation
                        }
                        .padding(.horizontal)
                    }

                    Spacer()

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Button(action: {
                        if !isFormValid {
                            if firstName.isEmpty || lastName.isEmpty || gender.isEmpty {
                                errorMessage = "Please fill in all the fields."
                            } else if !isEmailValid {
                                errorMessage = "Please enter a valid email address."
                            } else if !isPasswordValid {
                                errorMessage = "Password must be at least 6 characters long and contain at least one uppercase letter."
                            } else if confirmPassword.isEmpty {
                                errorMessage = "Please confirm your password."
                            } else if password != confirmPassword {
                                errorMessage = "Passwords do not match."
                            }
                        } else {
                            isLoading = true // Show loading indicator
                            viewModel.createUser(firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth.ISO8601Format(.iso8601), gender: gender, emailId: emailID, password: password, confirmPassword: confirmPassword) { result in
                                switch result {
                                case .success(let token):
                                    print("User created successfully! \(token)")
                                    self.showingOTPVerification = true
                                case .failure(let error):
                                    errorMessage = "Error creating: \(error.localizedDescription)"
                                }
                                isLoading = false // Hide loading indicator
                            }
                        }
                    }) {
                        Text("Continue")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                    
                    NavigationLink(destination: OTPView(email: emailID), isActive: self.$showingOTPVerification) {
                        EmptyView()
                    }

                    NavigationLink(destination: LoginView(), label: {
                        Text("Back to SignIn page")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .padding(.horizontal)
                    })
                    .padding(.bottom, 20)
                }
                .navigationBarTitle("", displayMode: .inline)
                .background(
                    // Add any background styling here
                    Color.white
                )
                
                if isLoading {
                    Color.black.opacity(0.5) // Transparent background covering the entire screen
                        .edgesIgnoringSafeArea(.all)
                    ProgressView() // Loader displayed on top
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2) // Increase size of the loader
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView().environmentObject(AuthViewModel())
    }
}

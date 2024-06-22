//
//  AuthViewModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import Foundation

@MainActor
class AuthViewModel : ObservableObject {
    @Published var currentUserToken : String?
    @Published var tempCurrentToken : String?
    
    init() {
        let userToken = UserDefaults.standard.string(forKey: "accessToken")
        if let token = userToken {
            currentUserToken = token
            print("Token is present: \(token)")
        } else {
            currentUserToken = nil
            print("Token is not present")
        }
        tempCurrentToken = nil
    }
    
    func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
        currentUserToken = token
        print("Token saved: \(token)")
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        currentUserToken = nil
        print("Token deleted")
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        let urlString = "https://apihosp.squaash.xyz/api/v1/patients/login"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.jsonSerialization(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkRequest(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpResponse(0))) // Handle missing response
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let message = errorResponse["message"] as? String {
                    completion(.failure(.authenticationFailed(message)))
                } else {
                    completion(.failure(.httpResponse(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponseData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decodedResponse.token))
                self.currentUserToken = decodedResponse.token
                UserDefaults.standard.set(decodedResponse.token, forKey: "accessToken")
                
            } catch {
                completion(.failure(.jsonParsing(error)))
            }
            
        }.resume()
    }
    
    func createUser(firstName: String, lastName: String,dateOfBirth : String, gender: String, emailId: String, password: String, confirmPassword: String, completion: @escaping (Result<String, CreateUserError>) -> Void) {
        
        // Validate input fields
        guard !firstName.isEmpty, !lastName.isEmpty, !gender.isEmpty, !emailId.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            completion(.failure(.emptyFields))
            return
        }
        
        guard password == confirmPassword else {
            completion(.failure(.passwordMismatch))
            return
        }
        
        
        
        let url = URL(string: "https://apihosp.squaash.xyz/api/v1/patients/register")! // Consider using a constant or configuration
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "gender": gender,
            "dob": dateOfBirth,
            "email": emailId,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.jsonSerialization(error)))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkRequest(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpResponse(0))) // Handle missing response
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let serverMessage = errorResponse["message"] as? String {
                    completion(.failure(.serverError(serverMessage)))
                } else {
                    completion(.failure(.httpResponse(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponseData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                completion(.success(decodedResponse.token))
                self.tempCurrentToken = decodedResponse.token
                print("User creation successful!")
                
            } catch {
                completion(.failure(.jsonParsing(error)))
            }
        }.resume()
    }
    
    func signOutUser(){
        
    }
    
    func resendOTP() {
        // Code to resend OTP
    }
    
    func submitOTP(otpCode: String,completion: @escaping (Result<Void, SubmitOTPError>) -> Void) {
        
        let urlString = "https://apihosp.squaash.xyz/api/v1/patients/verify-email"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidResponseData)) // Consider a more specific error
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        
        let body: [String: Any] = [
            "otp": otpCode
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(.jsonSerialization(error)))
            return
        }
        guard let token = self.tempCurrentToken else{
            completion(.failure(.missingToken))
            return
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkRequest(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpResponse(0))) // Handle missing response
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let serverMessage = errorResponse["message"] as? String {
                    completion(.failure(.serverError(serverMessage)))
                } else {
                    completion(.failure(.httpResponse(httpResponse.statusCode)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponseData))
                return
            }
            
            do {
                print("OTP verification successful!")
                UserDefaults.standard.set(token, forKey: "accessToken")
                self.currentUserToken = token
                
            }
        }.resume()
    }
    
}

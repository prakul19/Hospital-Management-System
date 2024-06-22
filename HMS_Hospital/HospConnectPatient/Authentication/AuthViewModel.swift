//
//  AuthViewModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import Foundation

@MainActor
class AuthViewModel : ObservableObject{
    @Published var currentUserToken : String?
    @Published var tempCurrentToken : String?
    init(){
        let userToken = UserDefaults.standard.string(forKey: "accessToken");
        guard let token = userToken else{
            currentUserToken = nil
            print("Token is not present")
            return
        }
        currentUserToken = token
        print("Token is present")
        print(currentUserToken)
    }
    
    
    func loginUser(email: String, password: String, completion: @escaping (Result<String, LoginError>) -> Void) {
        let urlString = "https://apihosp.squaash.xyz/api/v1/admin/hospital/hospital-login"
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
            
            
            print(String(data: data!, encoding: .utf8))
            
            if let error = error {
                completion(.failure(.networkRequest(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.httpResponse(0))) // Handle missing response
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                if let data = data, let errorResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let _ = errorResponse["message"] as? String {
                    completion(.failure(.httpResponse(httpResponse.statusCode))) // Pass status code for debugging
                    return
                } else {
                    completion(.failure(.httpResponse(httpResponse.statusCode)))
                    return
                }
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
    
    func signOutUser(){
        UserDefaults.standard.removeObject(forKey: "accessToken")
        currentUserToken = nil
        print("Token deleted")
    }
    
}

//
//  DoctorViewModel.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import Foundation

// MARK: - Doctor ViewModel

class DoctorViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var doctors: [Doctor] = []
    // MARK: - Fetch Doctors

    func fetchDoctors(for specializationId: String) {
        // Check if the token exists in UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("No token available")
            return
        }
        
        // Ensure URL is valid
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/specialization/\(specializationId)") else {
            print("Invalid URL")
            return
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Perform network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors and unwrap data
            guard let data = data, error == nil else {
                print("Error fetching doctors:", error ?? "Unknown error")
                return
            }

            // Print raw JSON data (for debugging)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON data: \(jsonString)")
            }

            // Decode JSON data into Doctor array
            do {
                let decodedData = try JSONDecoder().decode([Doctor].self, from: data)
                DispatchQueue.main.async {
                    self.doctors = decodedData
                }
            } catch {
                print("Error decoding JSON:", error)
            }
        }.resume()
    }
}

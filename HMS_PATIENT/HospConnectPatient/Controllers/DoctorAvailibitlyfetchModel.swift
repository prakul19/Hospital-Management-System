//
//  DoctorAvailibitlyfetchModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 07/06/24.
//

import Foundation
import Combine

class DoctorAvailabilityFethingModel: ObservableObject {
    @Published var availability: [String: [String]] = [:]
    
    func fetchDoctorAvailabilityByID(doctorId: String, token: String) {
        // Ensure URL is valid
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/\(doctorId)/getAvailability") else {
            print("Invalid URL")
            return
        }
        
        // Configure the request
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Perform network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors and unwrap data
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return
            }
            
            do {
                // Decode JSON data into AvailabilityResponse
                let decodedResponse = try JSONDecoder().decode(AvailabilityResponse.self, from: data)
                var availabilityDict: [String: [String]] = [:]
                
                // Process each availability entry
                for availability in decodedResponse.availability {
                    for slot in availability.slots {
                        let date = slot.date
                        var times: [String] = availabilityDict[date] ?? []
                        for timeSlot in slot.times {
                            times.append(timeSlot.time)
                        }
                        availabilityDict[date] = times
                    }
                }
                
                // Update the published availability dictionary
                DispatchQueue.main.async {
                    self.availability = availabilityDict
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        
        task.resume()
    }
}


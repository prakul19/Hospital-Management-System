//
//  DoctorViewModel.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import Foundation

// MARK: - Fetch Doctor Availability

/**
 Fetches the availability of a doctor for scheduling appointments.

 - Parameters:
    - doctorId: The ID of the doctor whose availability is being fetched.
    - token: The authentication token for API access.
    - completion: A closure that receives a dictionary mapping dates to available time slots.
 */
func fetchDoctorAvailability(doctorId: String, token: String, completion: @escaping ([String: Set<String>]) -> Void) {
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
            var availabilityDict: [String: Set<String>] = [:]

            // Process each availability entry
            for availability in decodedResponse.availability {
                for slot in availability.slots {
                    let date = slot.date
                    var times: Set<String> = availabilityDict[date] ?? []
                    for timeSlot in slot.times {
                        times.insert(timeSlot.time)
                    }
                    availabilityDict[date] = times
                }
            }

            // Call completion handler with the availability dictionary
            completion(availabilityDict)
        } catch {
            print("JSON parsing error: \(error)")
        }
    }

    task.resume()
}

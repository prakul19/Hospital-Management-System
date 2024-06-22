//
//  AppointmentsFetchedModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 07/06/24.
//

import Foundation
import Combine

class AppointmentService {
    // MARK: Fetch Appointments
    
    static func getAppointments(token: String, completion: @escaping (Result<[Appointment], Error>) -> Void) {
        // Construct URL for fetching appointments
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/patient") else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare request with authorization token
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        
        // Perform data task to fetch appointments
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            print("response of api \(response)")
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data in response"])))
                return
            }
            
            // Decode API response and extract appointments
            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(.success(response.appointments))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: Delete Appointment
    
    static func deleteAppointment(token: String, appointmentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        // Construct URL for deleting appointment
        let urlString = "https://apihosp.squaash.xyz/api/v1/appointment/patient/\(appointmentId)"
        print(appointmentId)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Prepare request with authorization token
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "authorization")
        
        // Perform data task to delete appointment
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            if httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to delete appointment"])))
            }
        }.resume()
    }

}

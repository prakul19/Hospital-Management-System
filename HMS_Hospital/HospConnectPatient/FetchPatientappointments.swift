//
//  FetchPatientappointments.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 11/06/24.
//

import Foundation

@MainActor func fetchAppointments(forPatientID patientID: String, with authViewModel: AuthViewModel, completion: @escaping (Result<[Appointment], Error>) -> Void) {
    guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/\(patientID)/patient") else {
        completion(.failure(APIError.invalidURL))
        return
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    if let token = authViewModel.currentUserToken {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    } else {
        completion(.failure(APIError.authenticationMissing))
        return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(APIError.noDataReceived))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(AppointmentResponse.self, from: data)
            completion(.success(decodedData.appointments))
        } catch {
            completion(.failure(error))
        }
    }.resume()
}

enum APIError: Error {
    case invalidURL
    case authenticationMissing
    case noDataReceived
}

//
//  deleteappointments.swift
//  HospConnectPatient
//
//  Created by apple on 10/06/24.
//

import Foundation

func deleteAppointments(token: String, appointmentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/patient/\(appointmentId)") else { return }
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                let errorMessage = "Failed to delete appointment with status code: \(httpResponse.statusCode)"
                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
            }
        } else {
            let errorMessage = "Invalid response"
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
        }
    }.resume()
}

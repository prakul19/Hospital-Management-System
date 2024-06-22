//
//  AppointmentService.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 08/06/24.
//

import Foundation

struct RescheduleRequest: Codable {
    let newDate: String
    let newTime: String
    let reschedulingReason: String
}

class AppointmentsService {
    static func getAppointments(token: String, completion: @escaping (Result<[Appointment], Error>) -> Void) {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/patient") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let data = data else {
                            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                            return
                        }
                        
                        do {
                            let appointments = try JSONDecoder().decode([Appointment].self, from: data)
                            completion(.success(appointments))
                        } catch {
                            completion(.failure(error))
                        }
                    }.resume()
                }

                static func rescheduleAppointment(token: String, appointmentId: String, rescheduleData: RescheduleRequest, completion: @escaping (Result<Appointment, Error>) -> Void) {
                    guard let url = URL(string: "http://localhost:8000/api/v1/appointment/\(appointmentId)/reschedule") else { return }
                    print(url)
                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    do {
                        request.httpBody = try JSONEncoder().encode(rescheduleData)
                        print("")
                    } catch {
                        completion(.failure(error))
                        return
                    }
                    
                    URLSession.shared.dataTask(with: request) { data, response, error in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                        
                        guard let data = data else {
                            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])))
                            return
                        }
                        
                        do {
                            let updatedAppointment = try JSONDecoder().decode(Appointment.self, from: data)
                            completion(.success(updatedAppointment))
                        } catch {
                            completion(.failure(error))
                        }
                    }.resume()
                }
            }

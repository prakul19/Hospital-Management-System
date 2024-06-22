//
//  PatientDataFetch.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 11/06/24.
//

import Foundation
import Combine

class PatientViewModel: ObservableObject {
    @Published var patients: [Patient] = []
    private var cancellable: AnyCancellable?
    
    init() {
        fetchPatients()
    }
    
    func fetchPatients() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/patients/all") else { // /appointment/:id/patient
            print("Invalid URL")
            return
        }
        
        print("Fetching patients from API")
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                print("Received data: \(String(data: data, encoding: .utf8) ?? "No data")")
            })
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .handleEvents(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error decoding data: \(error)")
                }
            })
            .receive(on: DispatchQueue.main)
            .replaceError(with: APIResponse(success: false, patients: []))
            .sink(receiveValue: { [weak self] response in
                print("Decoded patients: \(response.patients)")
                self?.patients = response.patients
            })
    }
}

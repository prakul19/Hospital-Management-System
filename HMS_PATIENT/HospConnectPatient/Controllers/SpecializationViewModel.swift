//
//  SpecializationViewModel.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import Foundation
import Combine

// MARK: - Specialization ViewModel

class SpecializationViewModel: ObservableObject {
    // MARK: - Properties

    @Published var services: [String: [Specialization]] = [:]
    private var cancellables = Set<AnyCancellable>()
    @Published var specializations: [Specialization]? = nil
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    // MARK: - Fetch Specializations

    func fetchSpecializations() {
        // Ensure URL is valid
        isLoading = true
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/specialization/specializations") else {
            print("Invalid URL")
            return
        }

        // Perform network request
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: SpecializationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching specializations: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                // Update services with fetched specializations
                self?.services = ["Specializations": response.specializations]
            })
            .store(in: &cancellables)
    }
}

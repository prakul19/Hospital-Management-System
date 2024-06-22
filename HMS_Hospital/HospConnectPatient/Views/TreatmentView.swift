//
//  TreatmentView.swift
//  HospConnectPatient
//
//  Created by Harsh Goyal on 06/06/24.
//

import SwiftUI
import Combine

struct TreatmentView: View {
    
    @ObservedObject var viewModel = SpecializationViewModel()
    
    var body: some View {
        ScrollView {
            ZStack{
                // Background color
                Color(.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        if let specializations = viewModel.services["Specializations"] {
                            ForEach(specializations) { specialization in
                                ServiceItem(title: specialization.commonNames)
                            }
                        } else {
                            Text("Loading...")
                        }
                    }
                    .offset(y:20)
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Services")
            .onAppear {
                viewModel.fetchSpecializations()
                
            }
        }
    }
}

struct ServiceItem: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .padding()
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}

#Preview {
    TreatmentView()
}


class SpecializationViewModel: ObservableObject {
    @Published var services: [String: [Specialization]] = [:] // Change to dictionary

    private var cancellables = Set<AnyCancellable>()

    func fetchSpecializations() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/specialization/specializations") else {
            print("Invalid URL")
            return
        }

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
                self?.services = ["Specializations": response.specializations] // Update dictionary with an array
            })
            .store(in: &cancellables)
    }
}


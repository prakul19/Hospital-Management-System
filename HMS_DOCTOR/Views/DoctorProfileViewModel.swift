//import Foundation
//import Combine
//
//class DoctorProfileViewModel: ObservableObject {
//    @Published var doctor: DoctorProfile.Doctor?
//    @Published var isLoading = false
//    @Published var error: String?
//
//    private var cancellables = Set<AnyCancellable>()
//
//    func fetchProfile() {
//        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/profile") else {
//            self.error = "Invalid URL"
//            return
//        }
//        
//        isLoading = true
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwNjk4MiwiZXhwIjoxNzIwNjk4OTgyfQ.33lMAxeewLpDz8sbsHVuQ7HszbgSdHcZ3fwjrKPQUzw", forHTTPHeaderField: "Authorization")
//        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .tryMap { output in
//                guard let response = output.response as? HTTPURLResponse else {
//                    throw URLError(.badServerResponse)
//                }
//                print("HTTP Status Code: \(response.statusCode)")
//                print("Response: \(String(data: output.data, encoding: .utf8) ?? "No data")")
//                guard response.statusCode == 200 else {
//                    throw URLError(.badServerResponse)
//                }
//                return output.data
//            }
//            .decode(type: DoctorProfile.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                self.isLoading = false
//                if case .failure(let error) = completion {
//                    self.error = error.localizedDescription
//                }
//            } receiveValue: { response in
//                self.doctor = response.doctor
//            }
//            .store(in: &self.cancellables)
//    }
//}
////


import Foundation
import Combine

class DoctorProfileViewModel: ObservableObject {
    @Published var doctor: DoctorProfile.Doctor?
    @Published var isLoading = false
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()

    func fetchProfile() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/profile") else {
            self.error = "Invalid URL"
            return
        }
        
        isLoading = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwNjk4MiwiZXhwIjoxNzIwNjk4OTgyfQ.33lMAxeewLpDz8sbsHVuQ7HszbgSdHcZ3fwjrKPQUzw", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                print("HTTP Status Code: \(response.statusCode)")
                print("Response: \(String(data: output.data, encoding: .utf8) ?? "No data")")
                guard response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: DoctorProfile.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.error = error.localizedDescription
                }
            } receiveValue: { response in
                self.doctor = response.doctor
            }
            .store(in: &self.cancellables)
    }
}

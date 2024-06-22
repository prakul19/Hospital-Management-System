import SwiftUI
import Combine

class AllPatientListViewModel: ObservableObject {
    @Published var patients: [AllPatient] = []
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchPatients(token: String) {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/patient/list") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwNjk4MiwiZXhwIjoxNzIwNjk4OTgyfQ.33lMAxeewLpDz8sbsHVuQ7HszbgSdHcZ3fwjrKPQUzw", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Network error. Please try again."
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server."
                }
                return
            }

            // Print raw data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }

            do {
                let response = try JSONDecoder().decode(AllPatientResponse.self, from: data)
                DispatchQueue.main.async {
                    self.patients = response.patients
                }
            } catch {
                print("Failed to decode response: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response from server."
                }
            }
        }.resume()
    }
}


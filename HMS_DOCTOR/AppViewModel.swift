import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var doctorId: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String?
    @Published var isLoggedIn: Bool = false
    @Published var token: String?
    @Published var appointments: [Appointment] = []
    
    init(){
        print("this is called")
        let userToken = UserDefaults.standard.string(forKey: "accessToken");
        guard let token = userToken else{
            self.token = nil;
            self.isLoggedIn = false
            print("token is not present when app opens")
            return;
        }
        self.token = token
        self.isLoggedIn = true
        print("token is present when app opens")
    }

    func login() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/doctor/login") else {
            print("Invalid URL")
            return
        }
        
        let doctor = Doctor(doctorId: doctorId, password: password)
        guard let loginData = try? JSONEncoder().encode(doctor) else {
            print("Failed to encode doctor data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = loginData
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Network error. Please try again."
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received from server."
                }
                return
            }
            
            print("Response data: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            do {
                let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.success {
                        print("Login successful")
                        self?.token = response.token
                        print("login token check \(response.token)")
                        UserDefaults.standard.set(response.token, forKey: "accessToken")
                        self?.isLoggedIn = true
                        self?.fetchAppointments()
                    } else {
                        print("Login failed")
                        self?.errorMessage = "Invalid doctorId or password."
                    }
                }
            } catch {
                print("Failed to decode response: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Enter a valid doctorId or password"
                }
            }
        }.resume()
    }
    func signOut(){
        UserDefaults.standard.removeObject(forKey: "accessToken");
        self.isLoggedIn = false
        self.token = nil
    }
    
    func fetchAppointments() {
        guard let token = token, let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/doctor") else {
            print("Invalid URL or token")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Network error. Please try again."
                }
                return
            }

            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    self?.errorMessage = "No data received from server."
                }
                return
            }

            do {
                let response = try JSONDecoder().decode(AppointmentResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.appointments = response.appointments
                }
            } catch {
                print("Failed to decode response: \(error)")
                DispatchQueue.main.async {
                    self?.errorMessage = "Failed to decode response from server."
                }
            }
        }.resume()
    }
}

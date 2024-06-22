import SwiftUI
import Combine

struct AppointmentResponse: Codable {
    let success: Bool
    let appointments: [Appointment]
}

struct Appointment: Codable, Identifiable {
    let id: String
    let status: String
    let patientID: Patient
    let meetType: String
    let doctorID: String
    let specializationID: Specialization
    let date: String
    let timeSlot: String
    let symptoms: String
    let createdAt: String
    let updatedAt: String
    let prescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case status
        case patientID
        case meetType
        case doctorID
        case specializationID
        case date
        case timeSlot
        case symptoms
        case createdAt
        case updatedAt
        case prescription
    }
}

struct Patient: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let gender: String
    let dob: String
    let email: String
    let isVerified: Bool
    let profileImage: String
    let contact: String?
    let bloodGroup: String?
    let address: String?
    let height: Double?
    let weight: Double?
    let role: String
    let otp: String?
    let ailments: [String]
    let symptoms: [String]
    let appointments: [String]
    let patientId: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case gender
        case dob
        case email
        case isVerified
        case profileImage
        case contact
        case bloodGroup
        case address
        case height
        case weight
        case role
        case otp
        case ailments
        case symptoms
        case appointments
        case patientId
        case version = "__v"
    }
}

struct Specialization: Codable {
    let id: String
    let specializationName: String
    let commonNames: String
    let doctorIDs: [String]
    let version: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case specializationName
        case commonNames
        case doctorIDs
        case version = "__v"
        case imageUrl
    }
}



struct UpcommingAppointmentsView: View {
    @State private var selectedTab = 0
    @State private var selectedAppointment: Appointment? = nil
    @State private var isPresentingDetail = false
    @State private var appointments: [Appointment] = []
    
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Upcoming \nAppointments")
                        .font(.largeTitle)
                        .bold()
                }
                .padding([.top, .horizontal])
                
                SegmentedControlView(selectedIndex: $selectedTab, titles: ["Clinic visit", "Video chats"])
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(filteredAppointments(), id: \.id) { appointment in
                            UpcommingAppointmentCardView(appointment: appointment) {
                                selectedAppointment = appointment
                                isPresentingDetail = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding(.bottom)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $isPresentingDetail) {
                if let selectedAppointment = selectedAppointment {
                    PrescriptionDetailView(patient: selectedAppointment.patientID, appointment: selectedAppointment)
                }
            }
            .onAppear {
                fetchAppointments()
            }
        }
    }

    private func fetchAppointments() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/doctor/") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwNjk4MiwiZXhwIjoxNzIwNjk4OTgyfQ.33lMAxeewLpDz8sbsHVuQ7HszbgSdHcZ3fwjrKPQUzw", forHTTPHeaderField: "authorization")

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
                let response = try JSONDecoder().decode(AppointmentResponse.self, from: data)
                DispatchQueue.main.async {
                    self.appointments = response.appointments
                }
            } catch {
                print("Failed to decode response: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response from server."
                }
            }
        }.resume()
    }

    private func filteredAppointments() -> [Appointment] {
        if selectedTab == 0 {
            return appointments.filter { $0.meetType == "clinic" }
        } else {
            return appointments.filter { $0.meetType == "virtual" }
        }
    }
}



struct UpcommingAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        UpcommingAppointmentsView()
    }
}


import SwiftUI
import Combine


struct PreviousAppointmentsView: View {
    @State private var selectedAppointment: Appointment? = nil
    @State private var isPresentingDetail = false
    @State private var selectedTab = 0
    @State private var appointments: [Appointment] = []
    @State private var errorMessage: String?
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Previous \nAppointments")
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
                            PreviousAppointmentCardView(appointment: appointment){
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
            .onAppear {
                fetchAppointments()
            }
        }
    }

    private func fetchAppointments() {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/doctor") else {
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
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: today)
        
        return appointments.filter { appointment in
            if selectedTab == 0 {
                return appointment.meetType == "clinic" && appointment.date < todayString
            } else {
                return appointment.meetType == "virtual" && appointment.date < todayString
            }
        }
    }
}

struct PreviousAppointmentCardView: View {
    var appointment: Appointment
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(appointment.patientID.firstName + " " + appointment.patientID.lastName)
                        .foregroundColor(.black)
                        .font(.headline)
                    Text(appointment.symptoms)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formatDate(appointment.date)).foregroundStyle(.red)
                    Text(formatTime(appointment.timeSlot))
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
        }
    }
    
    private func formatDate(_ date: String) -> String {
        return String(date.prefix(10))
    }
    
    private func formatTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm" // Assuming the timeSlot is in 24-hour format
        if let date = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        return time // Return the original time if parsing fails
    }
}


struct SectionHeader: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .bold()
            .foregroundColor(.gray)
            .padding(.top)
    }
}

struct PreviousAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        PreviousAppointmentsView()
    }
}


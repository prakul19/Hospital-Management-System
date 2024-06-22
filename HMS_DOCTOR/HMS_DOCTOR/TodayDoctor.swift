
import SwiftUI

struct MainView: View {
    @Binding var isLoggedIn: Bool
    @Binding var doctorId: String
    @Binding var password: String
    @Binding var appointments: [Appointment]
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        TabView {
            PatientScheduleView(appointments: $appointments)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Today")
                    }
                }
            
            AppointmentsView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Appointments")
                    }
                }
            
            ProfileView(isLoggedIn: $isLoggedIn, doctorId: $doctorId, password: $password)
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                }
        }
        .onAppear {
            viewModel.fetchAppointments()
        }
    }
}

struct PatientScheduleView: View {
    @Binding var appointments: [Appointment]
    @State private var selectedTab = 0
    @State private var isAvailabilityViewPresented = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HStack {
                    Text("Today")
                        .font(.largeTitle)
                        .bold()
                    Text("23 May")
                        .font(.title2)
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        isAvailabilityViewPresented.toggle()
                    }) {
                        Image(systemName: "calendar")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                    .sheet(isPresented: $isAvailabilityViewPresented) {
                        AvailabilityView()
                    }
                }
                .padding(.horizontal)
                
                // Segmented control
                SegmentedControlView(selectedIndex: $selectedTab, titles: ["Clinic Visits", "Video Chats"])
                    .padding()
                
                Text("My Patients")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView {
                    VStack(spacing: 10) {
                        if selectedTab == 0 {
                            ForEach(appointments) { appointment in
                               PatientRow (appointment: appointment)
                            }
                        } else {
                            // Placeholder for Video Chats, implement similar to Clinic Visits
                            Text("No Video Chats Available")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 8)
                }
            }
        }
    }
}

struct PatientRow: View {
    var appointment: Appointment
    @State private var isDetailViewPresented = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(appointment.patientID.firstName) \(appointment.patientID.lastName)")
                    .font(.headline)
                Text(truncateSymptoms(appointment.symptoms))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text(formatTime(appointment.timeSlot))
                .font(.subheadline)
            Button(action: {
                isDetailViewPresented.toggle()
            }) {
                Text("View")
                    .foregroundColor(.green)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
            }
            .sheet(isPresented: $isDetailViewPresented) {
                PatientDetailView(patient: appointment.patientID, appointment: appointment)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
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
    
    private func truncateSymptoms(_ symptoms: String) -> String {
        if symptoms.count > 20 {
            let index = symptoms.index(symptoms.startIndex, offsetBy: 20)
            return String(symptoms[..<index]) + "..."
        }
        return symptoms
    }
}



struct SegmentedControlView: View {
    @Binding var selectedIndex: Int
    let titles: [String]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<titles.count, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                }) {
                    Text(titles[index])
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedIndex == index ? Color.green : Color.gray.opacity(0.2))
                        .foregroundColor(selectedIndex == index ? .white : .black)
                }
            }
        }
        .frame(height: 40)
        .cornerRadius(10)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(
            isLoggedIn: .constant(true),
            doctorId: .constant(""),
            password: .constant(""),
            appointments: .constant([]),
            viewModel: AppViewModel()
        )
    }
}

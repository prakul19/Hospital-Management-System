import SwiftUI

struct VideoChat: View {
    // MARK: - State Properties
    @StateObject var specializationViewModel = SpecializationViewModel()
    @StateObject private var viewModel = DoctorViewModel()
    @StateObject private var viewPatientModel = AuthViewModel()
    @StateObject private var availModel = DoctorAvailabilityFethingModel()
    @State private var selectedDate: String? = nil
    @State private var selectedTime: String? = nil
    @State private var selectedSpecialization: Specialization? = nil
    @State private var selectedDoctor: Doctor? = nil
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var priority: String? = nil
    @State private var symptomsDescription = ""
    @State private var navigateToCheckups = false
    @State private var navigateToHome = false
    @State private var emailDisplayed: String = ""
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Constants
    let priorities = ["Low", "Medium", "High"]
    
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack(spacing: 16) {
                    List {
                        Section {
                            treatmentSection
                            doctorSection
                            prioritySection
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .frame(height: 165)
                    
                    Text("Priority patients are charged extra*")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    additionalInfoSection
                }
                .background(Color(UIColor.systemGroupedBackground))
            }
            
            Button(action: {
                bookAppointment()
            }) {
                Text("Book an appointment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom)
            .background(Color(UIColor.systemGroupedBackground))
        }
        .background(Color(UIColor.systemGroupedBackground)) // This line ensures the background color covers the full view
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Appointment Status"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    if alertMessage.contains("successfully") {
                        navigateToCheckups = true
                        // Reset all user input
                        selectedDate = nil
                        selectedTime = nil
                        selectedSpecialization = nil
                        selectedDoctor = nil
                        priority = nil
                        symptomsDescription = ""
                    }
                    showingAlert = false // Dismiss the alert when OK is tapped
                }
            )
        }
        .navigationBarTitle("Virtual Meet", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            specializationViewModel.fetchSpecializations()
            if let firstDate = availModel.availability.keys.sorted().first {
                selectedDate = firstDate
                selectedTime = availModel.availability[firstDate]?.first
            }
        }
    }
    
    // MARK: - Sections
    
    private var treatmentSection: some View {
        Section {
            HStack {
                Text("Treatment")
                Spacer()
                Menu {
                    if let specializations = specializationViewModel.services["Specializations"] {
                        ForEach(specializations, id: \.id) { specialization in
                            Button(action: {
                                self.selectedSpecialization = specialization
                                // Fetch doctors for the selected specialization
                                viewModel.fetchDoctors(for: specialization.id)
                            }) {
                                Text(specialization.commonNames)
                            }
                        }
                    } else {
                        Text("Loading...")
                    }
                } label: {
                    HStack {
                        Text(selectedSpecialization?.commonNames ?? "Not Selected")
                            .foregroundColor(.green)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
    
    private var doctorSection: some View {
        Section {
            HStack {
                Text("Doctor")
                Spacer()
                Menu {
                    ForEach(viewModel.doctors, id: \.self) { doctor in
                        Button(action: {
                            self.selectedDoctor = doctor
                            self.selectedDate = nil
                            self.selectedTime = nil
                            self.availModel.fetchDoctorAvailabilityByID(doctorId: doctor.id, token: viewPatientModel.currentUserToken!)
                            self.emailDisplayed = doctor.email
                        }) {
                            Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                        }
                    }
                    if viewModel.doctors.isEmpty {
                        Text("No doctors found for this specialization")
                    }
                } label: {
                    HStack {
                        Text(selectedDoctor?.firstName ?? "Not Selected")
                            .foregroundColor(.green)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
    
    private var prioritySection: some View {
        Section {
            HStack {
                Text("Email ID")
                Spacer()
                Text(emailDisplayed == "" ? "NA" : emailDisplayed)
            }
        }
    }
    
    private var additionalInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading) {
                Text("Symptoms description")
                    .font(.headline)
                TextField("What problem are you facing?", text: $symptomsDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 4)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Schedule")
                    .font(.headline)
                
                if availModel.availability.keys.isEmpty {
                    HStack{
                        Spacer()
                        Text("Nothing to show here")
                        Spacer()
                    }
                    .padding()
                    .foregroundColor(.gray)
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(Array(availModel.availability.keys.sorted()), id: \.self) { date in
                                Button(action: {
                                    selectedDate = date
                                    selectedTime = nil
                                }) {
                                    VStack {
                                        let dateComponents = date.split(separator: "T").first?.split(separator: "-")
                                        if let day = dateComponents?.last {
                                            Text(String(day))
                                                .font(.title)
                                                .foregroundColor(selectedDate == date ? .white : .black)
                                        } else {
                                            Text("Invalid date format")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .frame(width: 77, height: 77)
                                    .background(selectedDate == date ? Color.green : Color.white)
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            // Display time slots
            VStack(alignment: .leading) {
                if let selectedDate = selectedDate {
                    Text("Choose time")
                        .font(.headline)
                        .padding(.horizontal) // Add padding to the headline
                    
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ], spacing: 16) { // Add spacing between the grid items
                            if let times = availModel.availability[selectedDate] {
                                ForEach(Array(times.prefix(6)), id: \.self) { time in // Display only 6 items to fit 2x3 grid
                                    Button(action: {
                                        selectedTime = time
                                    }) {
                                        Text(time)
                                            .padding()
                                            .frame(maxWidth: .infinity) // Make the buttons take full width of the cell
                                            .background(selectedTime == time ? Color.green : Color.white)
                                            .cornerRadius(35)
                                            .foregroundColor(selectedTime == time ? .white : .black)
                                    }
                                }
                            } else {
                                Text("Nothing to show")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal) // Add padding to the ScrollView
                        .cornerRadius(10) // Add corner radius to the ScrollView
                    }
                }
            }
        }
    }
    
    func processResponse(data: Data) {
        do {
            // Deserialize the JSON data
            let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            // Print the entire response
            print("Response: \(String(describing: response))")
            
            // Extract and store the patientID separately
            if let appointment = response?["appointment"] as? [String: Any],
               let patientID = appointment["patientID"] as? String {
                patientGlobalID = patientID
            } else {
                print("Could not find patientID in the response.")
            }
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
        }
        
        // Print the patientGlobalID if it was found
        if let patientGlobalID = patientGlobalID {
            print("Patient Global ID: \(patientGlobalID)")
        } else {
            print("Patient Global ID is not available.")
        }
    }
    
    func bookAppointment() {
        guard let token = viewPatientModel.currentUserToken,
              let date = selectedDate,
              let time = selectedTime,
              !symptomsDescription.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showingAlert = true
            return
        }
        
        let appointmentDetails: [String: Any] = [
            "meetType": "virtual", // Meet type should remain "clinic"
            "doctorId": selectedDoctor?.id ?? "",
            "specializationID": selectedSpecialization?.id ?? "",
            "date": date,
            "time": time,
            "symptoms": symptomsDescription,
            "priority": "High" // Priority set to "High"
        ]
        
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/patient/schedule") else {
            alertMessage = "Invalid URL"
            showingAlert = true
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: appointmentDetails, options: [])
            request.httpBody = jsonData
            
        } catch {
            alertMessage = "JSON serialization error: \(error)"
            showingAlert = true
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                alertMessage = "Network error: \(String(describing: error?.localizedDescription ?? "Unknown error"))"
                showingAlert = true
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        alertMessage = "Appointment booked successfully. You can view your appointment in Check-ups."
                    } else if httpResponse.statusCode == 400 {
                        if let responseString = String(data: data, encoding: .utf8), responseString.contains("You have already booked this slot") {
                            alertMessage = "You have already booked this slot."
                        } else {
                            alertMessage = "You have already booked this slot"
                        }
                    } else {
                        alertMessage = "Server error: \(httpResponse.statusCode)"
                    }
                    showingAlert = true
                }
            }
            
            // Process and print the response
            processResponse(data: data)
        }
        
    
        task.resume()
    }
}

struct VideoChat_Previews: PreviewProvider {
    static var previews: some View {
        VideoChat()
    }
}


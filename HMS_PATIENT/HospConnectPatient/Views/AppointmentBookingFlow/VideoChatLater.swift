import SwiftUI

var patientGlobalID: String?

struct VideoChatLater: View {
    // MARK: - Properties
    
    let doctor: Doctor
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate: String? = nil
    @State private var selectedTime: String? = nil
    @State private var alertMessage = ""
    @State private var priority: String? = nil
    @State private var symptomsDescription = ""
    @State private var navigateToCheckups = false
    @State private var showingAlert = false // Add this line
    
    @State private var availableDates: Set<String> = []
    @State private var availableTimes: Set<String> = []

    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // MARK: - Doctor Information
                List {
                    HStack {
                        Text("Specialist")
                        Spacer()
                        Text(doctor.specialization.specializationName)
                    }
                    HStack {
                        Text("Doctor Name")
                        Spacer()
                        Text("Dr. \(doctor.firstName) \(doctor.lastName)")
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(doctor.email)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .frame(height: 165)
                
                Group {
                    VStack(alignment: .leading, spacing: 16) {
                        // MARK: - Symptoms Description
                        VStack(alignment: .leading) {
                            Text("Symptoms description")
                                .font(.headline)
                            TextField("What is the problem you are facing?", text: $symptomsDescription)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.top, 4)
                        }
                        .padding(.horizontal)

                        // MARK: - Schedule Selection
                        VStack(alignment: .leading) {
                            Text("Schedule")
                                .font(.headline)
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack {
                                    ForEach(availableDates.sorted(), id: \.self) { date in
                                        Button(action: {
                                            selectedDate = date
                                            if let token = viewModel.currentUserToken {
                                                fetchDoctorAvailability(doctorId: doctor.id, token: token) { availabilityDict in
                                                    DispatchQueue.main.async {
                                                        self.availableTimes = availabilityDict[date] ?? []
                                                    }
                                                }
                                            } else {
                                                print("No token found")
                                            }
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
                        .padding(.horizontal)

                        // MARK: - Choose Time
                        VStack(alignment: .leading) {
                            Text("Choose time")
                                .font(.headline)
                            ScrollView {
                                LazyVGrid(columns: [
                                    GridItem(.flexible(), spacing: 10),
                                    GridItem(.flexible(), spacing: 10)
                                ], spacing: 10) {
                                    ForEach(availableTimes.sorted(), id: \.self) { time in
                                        Button(action: {
                                            selectedTime = time
                                        }) {
                                            Text(time)
                                                .padding()
                                                .frame(maxWidth: .infinity)
                                                .background(selectedTime == time ? Color.green : Color.white)
                                                .cornerRadius(35)
                                                .foregroundColor(selectedTime == time ? .white : .black)
                                        }
                                        .frame(maxWidth: .infinity)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()

                // MARK: - Book Appointment Button
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
                .padding()
                .padding(.top, 16)
                .padding(.bottom)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationBarItems(leading: Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }, trailing: EmptyView())
            .navigationBarTitle("Clinic Visit", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if let token = viewModel.currentUserToken {
                    fetchDoctorAvailability(doctorId: doctor.id, token: token) { availabilityDict in
                        DispatchQueue.main.async {
                            self.availableDates = Set(availabilityDict.keys)
                            // Initially set the available times for the first date
                            if let firstDate = availabilityDict.keys.first {
                                self.selectedDate = firstDate // Selecting the first date by default
                                self.availableTimes = availabilityDict[firstDate] ?? []
                            }
                            print("Available dates: \(self.availableDates)")
                            print("Available times: \(self.availableTimes)")
                        }
                    }
                } else {
                    print("No token found")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Message"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Booking Appointment
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
            print("PatientGlobal ID is not available.")
        }
    }
    
    func bookAppointment() {
        guard let token = viewModel.currentUserToken else {
            alertMessage = "Token not available"
            showingAlert = true
            return
        }
        
        guard let date = selectedDate else {
            alertMessage = "Please select a date"
            showingAlert = true
            return
        }
        
        guard let time = selectedTime else {
            alertMessage = "Please select a time"
            showingAlert = true
            return
        }
        
        guard !symptomsDescription.isEmpty else {
            alertMessage = "Please enter symptoms description"
            showingAlert = true
            return
        }
        
        let appointmentDetails: [String: Any] = [
            "meetType": "virtual",
            "doctorId": doctor.id,
            "specializationID": doctor.specialization.id,
            "date": date,
            "time": time,
            "symptoms": symptomsDescription
        ]
        
        guard let url = URL(string: "http://localhost:8000/api/v1/appointment/patient/schedule") else {
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

// MARK: - Preview

struct VideoChatLater_Previews: PreviewProvider {
    static var previews: some View {
        ClinicViewLater(doctor: Doctor(
            id: "ii", firstName: "yyy", lastName: "yyy", dob: "08654", gender: "nbff",
            email: "ft@gm.com", phone: "34567890", state: "yui", city: "tyuio", pincode: "ertyu",
            address: "dfghjkl", experience: 8,
            specialization: SpecializationDetail(id: "tyui", specializationName: "tyui", commonNames: "ertyui")
        )).environmentObject(AuthViewModel())
    }
}



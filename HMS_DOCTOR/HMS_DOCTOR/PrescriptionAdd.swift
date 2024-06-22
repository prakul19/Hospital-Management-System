import SwiftUI

struct PrescriptionDetailView: View {
    var patient: Patient
    var appointment: Appointment
    @Environment(\.presentationMode) var presentationMode
    @State private var prescription: String = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.red)
                }
                Spacer()
                Button(action: {
                    updatePrescription(id: appointment.id)
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text(patient.firstName + " " + patient.lastName)
                        .font(.title)
                    Text("\(patient.gender) | \(calculateAge(from: patient.dob)) yr")
                        .font(.subheadline)
                }
                Spacer()
                Text(appointment.timeSlot)
                    .font(.subheadline)
            }
            .padding()

            HStack {
                Image(systemName: "calendar")
                Text(appointment.date)
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Image(systemName: "heart.text.square")
                Text(appointment.symptoms)
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Image(systemName: "phone")
                Text(patient.contact?.isEmpty == false ? patient.contact! : "N/A")
                Spacer()
            }
            .padding(.horizontal)

            Text("Prescription: \(appointment.prescription ?? "N/A")")
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            TextField("Enter today's prescription here", text: $prescription)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

            Button(action: {
                updatePrescription(id: appointment.id)
            }) {
                Text("Patient Visited")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }

            Spacer()
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }

    private func calculateAge(from dateString: String) -> Int {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return 0 }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }

    private func updatePrescription(id: String) {
        guard let url = URL(string: "https://apihosp.squaash.xyz/api/v1/appointment/doctor/\(id)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwMDg5MiwiZXhwIjoxNzIwNjkyODkyfQ.WslXKtXX0J1WvHEpkraix8z_3VkZ3r1FVrCUZ7xq6SE", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = ["prescription": prescription]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

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
                let response = try JSONDecoder().decode(PrescriptionResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.success {
                        self.presentationMode.wrappedValue.dismiss()
                    } else {
                        self.errorMessage = response.message
                    }
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

struct PrescriptionResponse: Codable {
    let success: Bool
    let message: String
}

struct PrescriptionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let patient = Patient(
            id: "666687b44d296ea55e2e44fd",
            firstName: "DDT",
            lastName: "Yyyy",
            gender: "Male",
            dob: "2024-01-15T18:26:00.000Z",
            email: "Fghj@gmail.com",
            isVerified: true,
            profileImage: "",
            contact: "1234567890",
            bloodGroup: "A+",
            address: "123 Street",
            height: nil,
            weight: nil,
            role: "user",
            otp: "",
            ailments: [],
            symptoms: [],
            appointments: [],
            patientId: "tcXNmCWEGa",
            version: 0
        )
        let appointment = Appointment(
            id: "666792a83cc10565f2baca21",
            status: "Scheduled",
            patientID: patient,
            meetType: "clinic",
            doctorID: "66669ede4d296ea55e2e479d",
            specializationID: Specialization(
                id: "66570818579f69d9940e5f1d",
                specializationName: "Cardiology",
                commonNames: "Heart Specialist",
                doctorIDs: [],
                version: 0,
                imageUrl: "https://www.getdoc.com/wp-content/uploads/2016/07/27faff5ddddd.jpg"
            ),
            date: "2024-06-13T19:09:27.000Z",
            timeSlot: "9-10",
            symptoms: "Hi",
            createdAt: "2024-06-10T23:56:24.378Z",
            updatedAt: "2024-06-11T09:16:06.744Z",
            prescription: "fdljs;a"
        )

        return PrescriptionDetailView(patient: patient, appointment: appointment)
    }
}

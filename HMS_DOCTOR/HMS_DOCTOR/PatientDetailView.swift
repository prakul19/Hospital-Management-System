import SwiftUI

struct PatientDetailView: View {
    var patient: Patient
    var appointment: Appointment
    @Environment(\.presentationMode) var presentationMode
    @State private var prescription: String = ""

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
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text("\(patient.firstName) \(patient.lastName)")
                        .font(.title)
//                    Text("\(patient.gender) | \(calculateAge(from: patient.dob)) yr")
//                        .font(.subheadline)
                    Text("\(patient.gender)")
                        .font(.subheadline)
                    
                }
                Spacer()
                Text(formatTime(appointment.timeSlot))
                    .font(.subheadline)
            }
            .padding()

            HStack {
                Image(systemName: "calendar")
                Text(truncateDate(appointment.date))
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

            Spacer()
        }
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


    private func calculateAge(from dateString: String) -> Int {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return 0 }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: date, to: Date())
        return ageComponents.year ?? 0
    }
    
    private func truncateDate(_ date: String) -> String {
        if date.count > 10 {
            let index = date.index(date.startIndex, offsetBy: 10)
            return String(date[..<index])
        }
        return date
    }
}

struct PatientDetailView_Previews: PreviewProvider {
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
        
        return PatientDetailView(patient: patient, appointment: appointment)
    }
}

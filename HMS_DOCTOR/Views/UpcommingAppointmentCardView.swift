
import SwiftUI

struct UpcommingAppointmentCardView: View {
    var appointment: Appointment
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading) {
                    Text(appointment.patientID.firstName + " " + appointment.patientID.lastName)
                        .font(.headline).foregroundStyle(.black)
                    Text(appointment.symptoms)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text(formatDate(appointment.date)).foregroundStyle(.green)
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



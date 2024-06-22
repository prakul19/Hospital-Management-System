import SwiftUI

struct AppointmentsView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Appointments")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                    .padding(.leading, 16)
                
                VStack(spacing: 40) { // Add a VStack to group the NavigationLinks with custom spacing
                    NavigationLink(destination: UpcommingAppointmentsView()) {
                        AppointmentCardView(title: "Upcoming Appointments", iconName: "calendar.badge.plus", destination: UpcommingAppointmentsView())
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: PreviousAppointmentsView()) {
                        AppointmentCardView(title: "Previous Appointments", iconName: "calendar.badge.checkmark",destination: PreviousAppointmentsView())
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination: AllPatientListView()) {
                        AppointmentCardView(title: "Patient List", iconName: "person.3",destination: AllPatientListView())
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20) // Add padding to the top of the VStack
                
                Spacer()
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct AppointmentCardView<Destination: View>: View {
    var title: String
    var iconName: String
    var destination: Destination
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer(minLength: 10)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.vertical, 20) // Add vertical padding
            .padding()
            .background(Color.green)
            .cornerRadius(10)
        }
    }
}

struct AppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AppointmentsView()
    }
}


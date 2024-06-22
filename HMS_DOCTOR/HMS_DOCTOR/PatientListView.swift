import SwiftUI

struct AllPatientListView: View {
    @ObservedObject var viewModel = AllPatientListViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Patient List")
                        .font(.largeTitle)
                        .bold()
                }
                .padding([.top, .horizontal])
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(viewModel.patients) { patient in
                            AllPatientCardView(patient: patient)
                        }
                    }
                    .padding(.horizontal)
                }
                
                if let errorMessage = viewModel.errorMessage {
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
                viewModel.fetchPatients(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2NjY5ZWRlNGQyOTZlYTU1ZTJlNDc5ZCIsImlhdCI6MTcxODEwNjk4MiwiZXhwIjoxNzIwNjk4OTgyfQ.33lMAxeewLpDz8sbsHVuQ7HszbgSdHcZ3fwjrKPQUzw")
            }
        }
    }
}

struct AllPatientCardView: View {
    var patient: AllPatient

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(patient.firstName) \(patient.lastName)")
                    .font(.headline)
                    .foregroundColor(.black)
                Text("PID: \(patient.patientId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}


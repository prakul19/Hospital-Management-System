//
//  AppointmentDetailView.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 13/06/24.
//

import Foundation
import SwiftUI

struct AppointmentDetailView: View {
    let appointment: Appointment
    @State private var newDate: String = ""
    @State private var newTime: String = ""
    @State private var isButtonEnabled: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    var onDeleteSuccess: () -> Void  // Completion handler

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text("Date:")
                        .font(.headline)
                    Text(appointment.date.split(separator: "T").first?.split(separator: "-").joined(separator: "/") ?? "")
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding([.leading, .trailing, .top])
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                  
                    Text("Symptoms")
                        .font(.headline)
                    Text(appointment.symptoms)
                        .font(.subheadline)
                }
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    Text("Time Slot:")
                        .font(.headline)
                    Text(appointment.timeSlot)
                        .font(.subheadline)
                }
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.gray)
                    Text("Meeting Type:")
                        .font(.headline)
                    Text(appointment.meetType)
                        .font(.subheadline)
                }
            }
            .padding([.leading, .trailing])
            
            Divider()
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Reschedule Appointment Reason")
                    .font(.headline)
                    .padding(.bottom, 5)
                
                HStack {
                    TextField("Give valid reason", text: $newDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: newDate) { _ in
                            checkFormValidity()
                        }
                }
            }
            .padding([.leading, .trailing])
            
            Button(action: {
                deleteAppointment()
            }) {
                Text("Delete Appointment")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isButtonEnabled ? Color.red : Color.gray)
            }
            .disabled(!isButtonEnabled)
            .padding([.leading, .trailing, .bottom])
            
            Spacer()
        }
        .background(Color.white)
        .cornerRadius(8)
        .padding()
    }

    private func checkFormValidity() {
        isButtonEnabled = !newDate.isEmpty
    }

    private func deleteAppointment() {
        guard let token = viewModel.currentUserToken else {
            print("No token available")
            return
        }
        
        deleteAppointments(token: token, appointmentId: appointment.id) { result in
            switch result {
            case .success:
                print("Appointment deleted successfully")
                DispatchQueue.main.async {
                    onDeleteSuccess()  // Call the completion handler
                    dismiss()
                }
            case .failure(let error):
                print("Error deleting appointment: \(error.localizedDescription)")
            }
        }
    }
}

    
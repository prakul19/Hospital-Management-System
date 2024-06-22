//
//  ConsultationOptions.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import SwiftUI

var cut_value: String = ""

struct ConsultationOptionsView: View {
    // MARK: - Properties
    
    @Environment(\.dismiss) private var dismiss
    
    let doctor: Doctor

    // MARK: - Body
    
    var body: some View {
        // Compute cut_value outside of the view body
        let specValue = doctor.specialization.specializationName
        if let index = specValue.firstIndex(of: "g") {
            cut_value = String(specValue[...index])
        } else {
            cut_value = specValue
        }
        
        return VStack(spacing: 24) {
            Text("How would you like to consult with\n\(doctor.firstName)?")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.top, 20)

            VStack(spacing: 24) {
                // In-Clinic Consultation Option
                NavigationLink(destination: ClinicViewLater(doctor: doctor)) {
                    ConsultationOptionCard(iconName: "plus.circle.fill", title: "Book In-Clinic Consultation", subtitle: "Consult with a \(cut_value)ist In-Clinic")
                        .frame(minHeight: 150)
                }

                // Video Consultation Option
                NavigationLink(destination: VideoChatLater(doctor: doctor)) {
                    ConsultationOptionCard(iconName: "video.circle.fill", title: "Book In-Video Consultation", subtitle: "Consult with a \(cut_value)ist via Video Call")
                        .frame(minHeight: 150)
                }
            }
            .padding(.horizontal, 45)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
        )
    }
}

struct ConsultationOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConsultationOptionsView(doctor: Doctor(id: "teetet", firstName: "jrrhrh", lastName: "hdhhd", dob: "hhhfh", gender: "hdhdh", email: "sagsy@gmail.com", phone: "hd7777", state: "ddudu", city: "hdhdh", pincode: "61616", address: "ydhdh", experience: 8, specialization: SpecializationDetail(id: "56789", specializationName: "cardiology", commonNames: "fjk")))
        }
    }
}

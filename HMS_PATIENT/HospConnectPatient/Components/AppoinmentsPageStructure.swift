//
//  AppoinmentsPageStructure.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 07/06/24.
//

import SwiftUI

struct AppointmentRow: View {
    @StateObject private var viewModel = DoctorViewModel()
    let appointment: Appointment
    
    var body: some View {
       HStack {
         Image(systemName: "person.crop.circle.fill")
           .resizable()
           .frame(width: 50, height: 50)
           .foregroundColor(.gray)

         VStack(alignment: .leading) {
             
           Text(appointment.symptoms)
             .font(.headline)
           // Find the doctor with matching ID and display firstName
             if let doctor = viewModel.doctors.first(where: { $0.id == appointment.doctorID.id }) {
                 Text(appointment.doctorID.firstName) // Print doctor's firstName here
               .font(.subheadline)
               .foregroundColor(.gray)
           } else {
             Text("satwik kanhere") // Handle case where doctor is not found
               .font(.subheadline)
               .foregroundColor(.gray)
           }
         }

         Spacer()

         VStack(alignment: .trailing) {
           Text(appointment.timeSlot)
             .font(.subheadline)
             .foregroundColor(.gray)
           Text(appointment.date.split(separator: "T").first?.split(separator: "-").joined(separator: "/") ?? "")
             .font(.subheadline)
             .foregroundColor(.gray)
         }
       }
       .padding()
       .background(Color.white)
       .cornerRadius(8)
       .shadow(radius: 1)
     }
   }

struct CustomSegmentedControl: UIViewRepresentable {
    @Binding var selectedIndex: Int
    var titles: [String]
    
    class Coordinator: NSObject {
        var parent: CustomSegmentedControl
        
        init(parent: CustomSegmentedControl) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISegmentedControl) {
            parent.selectedIndex = sender.selectedSegmentIndex
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = selectedIndex
        control.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        control.selectedSegmentTintColor = UIColor.systemGreen
        
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        uiView.selectedSegmentIndex = selectedIndex
    }
}

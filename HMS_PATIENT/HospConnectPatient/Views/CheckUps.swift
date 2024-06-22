//
//  CheckUps.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import SwiftUI

struct CheckUpsView: View {
    // MARK: - Properties
    @State private var selectedTab: Int = 0
    @State private var clinicAppointments: [Appointment] = []
    @State private var virtualAppointments: [Appointment] = []
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showModal: Bool = false
    @State private var selectedAppointment: Appointment?
    @State private var isFetchingData: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                header
                
                CustomSegmentedControl(selectedIndex: $selectedTab, titles: ["Clinic visit", "Video chats"])
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if selectedTab == 0 {
                            upcomingClinicAppointmentsSection
                            previousClinicAppointmentsSection
                        } else {
                            upcomingVirtualAppointmentsSection
                            previousVirtualAppointmentsSection
                        }
                    }
                }
            }
            .background(Color(.systemGray6))
            .navigationBarBackButtonHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Appointment Deleted"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            if isFetchingData {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .onAppear {
            fetchData()
        }
        .sheet(isPresented: $showModal) {
            if selectedTab == 0, let appointment = selectedAppointment {
                AppointmentDetailView(appointment: appointment) {
                    showAlertWith(message: "Your appointment is cancelled successfully")
                    fetchData()
                }
                .environmentObject(viewModel)
                .presentationDetents([.fraction(0.6)])
            } else if selectedTab == 1, let appointment = selectedAppointment {
                AppointmentDetailViewVirtual(appointment: appointment) {
                    showAlertWith(message: "Your appointment is cancelled successfully")
                    fetchData()
                }
                .environmentObject(viewModel)
                .presentationDetents([.fraction(0.6)])
            }
        }
    }

    // MARK: - Views
    private var header: some View {
        HStack {
            Text("Check-ups")
                .font(.largeTitle)
                .bold()
            
            Spacer()
        }
        .padding()
    }
    
    private var upcomingClinicAppointmentsSection: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Clinic Appointments")
                .font(.headline)
                .padding(.horizontal)
            
            let upcomingAppointments = clinicAppointments.filter { appointment in
                let isFutureOrToday = isFutureOrTodayDate(appointment.date)
                print("Upcoming: \(appointment.date) is future or today: \(isFutureOrToday)")
                return appointment.status == "Scheduled" && isFutureOrToday
            }
            ForEach(upcomingAppointments) { appointment in
                AppointmentRow(appointment: appointment)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedAppointment = appointment
                        showModal.toggle()
                    }
            }
        }
    }
    
    private var previousClinicAppointmentsSection: some View {
        VStack(alignment: .leading) {
            Text("Previous Clinic Appointments")
                .font(.headline)
                .padding(.horizontal)
            
            let previousAppointments = clinicAppointments.filter { appointment in
                let isFutureOrToday = isFutureOrTodayDate(appointment.date)
                print("Previous: \(appointment.date) is future or today: \(isFutureOrToday)")
                return appointment.status != "Scheduled" || !isFutureOrToday
            }
            ForEach(previousAppointments) { appointment in
                AppointmentRow(appointment: appointment)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedAppointment = appointment
                        showModal.toggle()
                    }
            }
        }
    }
    
    private var upcomingVirtualAppointmentsSection: some View {
        VStack(alignment: .leading) {
            Text("Upcoming Virtual Appointments")
                .font(.headline)
                .padding(.horizontal)
            
            let upcomingAppointments = virtualAppointments.filter { appointment in
                let isFutureOrToday = isFutureOrTodayDate(appointment.date)
                print("Upcoming: \(appointment.date) is future or today: \(isFutureOrToday)")
                return appointment.status == "Scheduled" && isFutureOrToday
            }
            ForEach(upcomingAppointments) { appointment in
                AppointmentRow(appointment: appointment)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedAppointment = appointment
                        showModal.toggle()
                    }
            }
        }
    }
    
    private var previousVirtualAppointmentsSection: some View {
        VStack(alignment: .leading) {
            Text("Previous Virtual Appointments")
                .font(.headline)
                .padding(.horizontal)
            
            let previousAppointments = virtualAppointments.filter { appointment in
                let isFutureOrToday = isFutureOrTodayDate(appointment.date)
                print("Previous: \(appointment.date) is future or today: \(isFutureOrToday)")
                return appointment.status != "Scheduled" || !isFutureOrToday
            }
            ForEach(previousAppointments) { appointment in
                AppointmentRow(appointment: appointment)
                    .padding(.horizontal)
                    .onTapGesture {
                        selectedAppointment = appointment
                        showModal.toggle()
                    }
            }
        }
    }
    
    // MARK: - Data
    private func fetchData() {
        isFetchingData = true
        guard let token = viewModel.currentUserToken else {
            print("No token available")
            return
        }

        AppointmentService.getAppointments(token: token) { result in
            switch result {
            case .success(let appointments):
                DispatchQueue.main.async {
                    self.clinicAppointments = appointments.filter { $0.meetType == "clinic" }
                    self.virtualAppointments = appointments.filter { $0.meetType == "virtual" }
                    print("Number of clinic appointments fetched: \(self.clinicAppointments.count)")
                    print("Number of virtual appointments fetched: \(self.virtualAppointments.count)")
                    self.isFetchingData = false
                }
            case .failure(let error):
                print("Error fetching appointments: \(error.localizedDescription)")
                self.isFetchingData = false
            }
        }
    }
    
    private func showAlertWith(message: String) {
        alertMessage = message
        showAlert = true
    }

    // MARK: - Previews
    struct CheckUpsView_Previews: PreviewProvider {
        static var previews: some View {
            CheckUpsView()
                .environmentObject(AuthViewModel())
        }
    }
    
    private func isFutureOrTodayDate(_ dateString: String) -> Bool {
        guard let date = dateFormatter.date(from: dateString) else {
            print("Invalid date format: \(dateString)")
            return false
        }
        let isFutureOrToday = Calendar.current.isDateInToday(date) || date > Date()
        print("Comparing date: \(dateString) with current date: \(Date()) - Result: \(isFutureOrToday)")
        return isFutureOrToday
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}

//
//  AppointmentsPatientModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 11/06/24.
//

import Foundation

struct Appointment: Codable, Identifiable {
    let id: String
    let patientID: String
    let meetType: String
    let doctorID: String
    let specializationID: String
    let date: String
    let timeSlot: String
    let symptoms: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let __v: Int

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientID = "patientID" // Change the key for patientID
        case meetType
        case doctorID
        case specializationID
        case date
        case timeSlot
        case symptoms
        case status
        case createdAt
        case updatedAt
        case __v
    }
    
    // Provide default values for properties
    init(id: String = "", patientID: String = "", meetType: String = "", doctorID: String = "", specializationID: String = "", date: String = "", timeSlot: String = "", symptoms: String = "", status: String = "", createdAt: String = "", updatedAt: String = "", __v: Int = 0) {
        self.id = id
        self.patientID = patientID
        self.meetType = meetType
        self.doctorID = doctorID
        self.specializationID = specializationID
        self.date = date
        self.timeSlot = timeSlot
        self.symptoms = symptoms
        self.status = status
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.__v = __v
    }
}

struct AppointmentResponse: Codable {
    let success: Bool
    let appointments: [Appointment]
}

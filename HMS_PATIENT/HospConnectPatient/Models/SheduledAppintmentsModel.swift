//
//  SheduledAppintments.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 07/06/24.
//

import Foundation

// MARK: - API Response Model

struct APIResponse: Codable {
    let success: Bool
    let appointments: [Appointment]
}

// MARK: - Appointment Model

struct Appointment: Identifiable, Codable {
    let id: String
    let patientID: Patient2
    let meetType: String
    let doctorID: Doctor2
    let specializationID: Specialization2
    let date: String
    let timeSlot: String
    let symptoms: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientID
        case meetType
        case doctorID
        case specializationID
        case date
        case timeSlot
        case symptoms
        case status
        case createdAt
        case updatedAt
        case v = "__v"
    }
}


struct Patient2: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let gender: String
    let dob: String
    let email: String
    let isVerified: Bool
    let profileImage: String
    let contact: String?
    let bloodGroup: String?
    let address: String?
    let height: Double?
    let weight: Double?
    let role: String
    let otp: String?
    let ailments: [String]
    let symptoms: [String]
    let appointments: [String]
    let patientId: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case gender
        case dob
        case email
        case isVerified
        case profileImage
        case contact
        case bloodGroup
        case address
        case height
        case weight
        case role
        case otp
        case ailments
        case symptoms
        case appointments
        case patientId
        case version = "__v"
    }
}
struct Specialization2: Codable {
    let id: String
    let specializationName: String
    let commonNames: String
    let doctorIDs: [String]
    let version: Int
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case specializationName
        case commonNames
        case doctorIDs
        case version = "__v"
        case imageUrl
    }
}



struct Doctor2: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let dob: String
    let gender: String
    let email: String
    let phone: String
    let state: String
    let city: String
    let pincode: String
    let address: String
    let experience: Int
    let specialization: String
    let availability: [String]
    let doctorId: String
    let version: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case dob
        case gender
        case email
        case phone
        case state
        case city
        case pincode
        case address
        case experience
        case specialization
        case availability
        case doctorId = "doctorID"
        case version = "__v"
    }
}

//
//  PatientModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 11/06/24.
//

import Foundation

struct Patient: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let gender: String
    let dob: String
    let email: String
    let isVerified: Bool
    let profileImage: String
    let contact: String
    let bloodGroup: String
    let address: String
    let height: Double?
    let weight: Double?
    let role: String
    let otp: String
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

struct APIResponse: Codable {
    let success: Bool
    let patients: [Patient]
}

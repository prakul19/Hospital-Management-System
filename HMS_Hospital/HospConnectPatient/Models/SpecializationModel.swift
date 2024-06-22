//
//  SpecializationModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 12/06/24.
//

import Foundation

struct SpecializationResponse: Codable {
    let specializations: [Specialization] // Change to array

    enum CodingKeys: String, CodingKey {
        case specializations
    }
}

//struct Specialization: Codable, Identifiable {
//    let id: String
//    let commonNames: String
//
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case commonNames
//    }
//}

struct Specialization: Codable, Identifiable, Hashable {
    let id: String
    let commonNames: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case commonNames
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Specialization, rhs: Specialization) -> Bool {
        return lhs.id == rhs.id
    }
}


struct DoctorData: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var dob: Date = Date()
    var gender: String = ""
    var email: String = ""
    var phone: String = ""
    var state: String = ""
    var city: String = ""
    var pincode: String = ""
    var address: String = ""
    var experience: String = ""
    var specialization: String = ""
    var medicalLicense: String = ""
    var educationDetails: String = ""
    var certifications: String = ""
}


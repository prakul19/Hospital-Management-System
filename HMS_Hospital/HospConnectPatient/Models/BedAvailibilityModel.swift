//
//  BedAvailibilityModel.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 11/06/24.
//

import Foundation

struct DeleteResponse: Codable {
    let success: Bool
    let message: String
}

struct BedResponse: Decodable {
    let success: Bool
    let beds: [Bed]
}

struct Bed: Identifiable, Decodable, Hashable {
    let id: String
    let hospitalID: String
    let bedNumber: String
    let status: String
    let specializationID: String
    let v: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case hospitalID
        case bedNumber
        case status
        case specializationID
        case v = "__v"
    }
}

struct AddBedResponse: Decodable {
    let success: Bool
    let bed: Bed
}

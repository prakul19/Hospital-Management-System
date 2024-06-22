//
//  DoctorDatafetchModel.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 06/06/24.
//

import Foundation

// MARK: - Availability Response

struct AvailabilityResponse: Codable {
    let success: Bool
    let availability: [DoctorAvailability]
}

// MARK: - Doctor Availability

struct DoctorAvailability: Codable {
    let id: String
    let doctor: String
    let weekStart: String
    let slots: [Slot]

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctor
        case weekStart
        case slots
    }
}

// MARK: - Slot

struct Slot: Codable {
    let day: String
    let date: String
    let times: [TimeSlot]

    enum CodingKeys: String, CodingKey {
        case day
        case date
        case times
    }
}

// MARK: - Time Slot

struct TimeSlot: Codable {
    let time: String
    let limit: Int
    let booked: Int
    let isActive: Bool
    let id: String

    enum CodingKeys: String, CodingKey {
        case time
        case limit
        case booked
        case isActive
        case id = "_id"
    }
}



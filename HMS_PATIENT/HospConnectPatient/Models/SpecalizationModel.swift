//
//  SpecializationModel.swift
//  HospConnectPatient
//
//  Created by Prakul Agarwal on 05/06/24.
//

import Foundation
import SwiftUI

// MARK: - Offer Model

struct Offer: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let url: String
}

// MARK: - Specialization Model

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
}

// MARK: - Specialization Response Model

struct SpecializationResponse: Codable {
    let specializations: [Specialization] // Change to array

    enum CodingKeys: String, CodingKey {
        case specializations
    }
}

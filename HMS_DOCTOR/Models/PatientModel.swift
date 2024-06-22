import Foundation

struct AllPatientResponse: Codable {
    let success: Bool
    let patients: [AllPatient]
}

struct AllPatient: Codable, Identifiable {
    let id: String
    let firstName: String
    let lastName: String
    let patientId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName
        case lastName
        case patientId
    }
}


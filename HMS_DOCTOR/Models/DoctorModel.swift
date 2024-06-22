//import Foundation
//
//struct DoctorProfile: Codable {
//    let success: Bool
//    let doctor: Doctor
//    
//    struct Doctor: Codable {
//        let _id: String
//        let firstName: String
//        let lastName: String
//        let dob: String
//        let gender: String
//        let email: String
//        let phone: String
//        let address: String
//    }
//}



import Foundation

struct DoctorProfile: Codable {
    let success: Bool
    let doctor: Doctor
    
    struct Doctor: Codable {
        let _id: String
        let firstName: String
        let lastName: String
        let dob: String
        let gender: String
        let email: String
        let phone: String
        let address: String
    }
}

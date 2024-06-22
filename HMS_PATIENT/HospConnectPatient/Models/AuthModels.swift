//
//  AuthModels.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import Foundation

// MARK: - Login Error

enum LoginError: Error {
    case invalidURL
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int)
    case invalidResponseData
    case jsonParsing(Error)
    case authenticationFailed(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .jsonSerialization(let error):
            return "JSON Serialization error: \(error.localizedDescription)"
        case .networkRequest(let error):
            return "Network request error: \(error.localizedDescription)"
        case .httpResponse(let statusCode):
            return "HTTP error with status code \(statusCode)."
        case .invalidResponseData:
            return "Invalid response data."
        case .jsonParsing(let error):
            return "JSON parsing error: \(error.localizedDescription)"
        case .authenticationFailed(let message):
            return message
        }
    }
}

// MARK: - Login Response

struct LoginResponse: Decodable {
    let token: String
}

// MARK: - Create User Error

enum CreateUserError: Error {
    case emptyFields
    case passwordMismatch
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int) // Capture status code for debugging
    case invalidResponseData
    case jsonParsing(Error)
    case serverError(String)
    // Add more cases as needed with descriptive messages
}

// MARK: - Submit OTP Error

enum SubmitOTPError: Error {
    case missingToken
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int) // Capture status code for debugging
    case invalidResponseData
    case jsonParsing(Error)
    case serverError(String)
    // Add more cases as needed with descriptive messages
}

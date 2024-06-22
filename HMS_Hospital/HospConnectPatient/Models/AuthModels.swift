//
//  AuthModels.swift
//  HospConnectPatient
//
//  Created by prakul agarwal on 05/06/24.
//

import Foundation

enum LoginError: Error {
    case invalidURL
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int) // Capture the status code for debugging
    case invalidResponseData
    case jsonParsing(Error)
    case tokenNotFound
}

struct LoginResponse: Decodable {
    let token: String
}


enum CreateUserError: Error {
    case emptyFields
    case passwordMismatch
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int) // Capture status code for debugging
    case invalidResponseData
    case jsonParsing(Error)
    case serverError(String)
}

enum SubmitOTPError: Error {
    case missingToken
    case jsonSerialization(Error)
    case networkRequest(Error)
    case httpResponse(Int) // Capture status code for debugging
    case invalidResponseData
    case jsonParsing(Error)
    case serverError(String)
}

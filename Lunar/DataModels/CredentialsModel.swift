//
//  CredentialsModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation
import SwiftUI

// MARK: - Login

struct CredentialsResponseModel: Codable {
    let jwt: String
    let registrationCreated: Bool?
    let verifyEmailSent: Bool?
}

struct CredentialsRequestModel: Encodable {
    let usernameOrEmail: String
    let password: String
    let twoFactorToken: String?
}

struct ErrorResponseModel: Codable {
    let error: String
}

struct UserInfoResponseModel: Codable {
    let username: String
    let email: String
}

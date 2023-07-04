//
//  CredentialsModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

struct CredentialsResponseModel: Codable {
  let jwt: String
  let registrationCreated: Bool?
  let verifyEmailSent: Bool?
}

struct CredentialsRequestModel: Encodable {
  let username_or_email: String
  let password: String
  let totp_2fa_token: String?
}

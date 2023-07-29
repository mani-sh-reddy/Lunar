//
//  LoginHelper.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

/// Retrieving JWT Token
/*  func getJWTFromKeychain() {
     let keychainObject = KeychainHelper.standard.read(service: self.appBundleID, account: self.usernameOrEmail)

     let accessToken = String(data: keychainObject, encoding: .utf8)!
     print(accessToken)
 }
 */

import Alamofire
import SwiftUI

class LoginHelper: ObservableObject {
    @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
    @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
    @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
    @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
    @Published var usernameOrEmail: String
    @Published var password: String
    @Published var twoFactorToken: String
    @Published var isMissing2FAToken: Bool = false
    @Published var loginFailed: Bool = false
    @Published var logInSuccessful: Bool = false

    init(usernameOrEmail: String, password: String, twoFactorToken: String) {
        self.usernameOrEmail = usernameOrEmail
        self.password = password
        self.twoFactorToken = twoFactorToken
    }

    func login(completion: @escaping () -> Void) {
        let endpoint = "https://\(instanceHostURL)/api/v3/user/login"
        let credentialsRequest = CredentialsRequestModel(
            username_or_email: usernameOrEmail,
            password: password,
            totp_2fa_token: twoFactorToken == "" ? nil : twoFactorToken
        )

        let headers: HTTPHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json",
        ]

        AF.request(endpoint, method: .post, parameters: credentialsRequest, encoder: JSONParameterEncoder.default, headers: headers)
            .responseDecodable(of: CredentialsModel.self) { response in
                switch response.result {
                case let .success(credentialsModel):
                    self.loginFailed = false
                    let jwt = credentialsModel.jwt
                    KeychainHelper.standard.save(jwt, service: self.appBundleID, account: self.usernameOrEmail)
                    self.loggedInUsersList.append(self.usernameOrEmail)
                    self.selectedUser = self.loggedInUsersList.last ?? ""
                    self.logInSuccessful = true
                    /// Calling the completion handler after the login process is completed
                    completion()

                case let .failure(error):
                    if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponseModel.self, from: data) {
                        print("LoginHelper ERROR: \(errorResponse.error)")
                        if errorResponse.error == "missing_totp_token" {
                            self.isMissing2FAToken = true
                        } else {
                            self.isMissing2FAToken = false
                            self.loginFailed = true
                        }
                    } else {
                        print("LoginHelper ERROR JSON DECODE: \(error)")
                        self.loginFailed = true
                    }
                    /// Calling the completion handler after the login process is completed
                    completion()
                }
            }
    }
}

//
//  LoginHelper.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Alamofire
import SwiftUI

/* **Retrieving JWT Token**
 func getJWTFromKeychain() {
 let keychainObject = KeychainHelper.standard.read(service: self.appBundleID, account: self.usernameEmail)

 let accessToken = String(data: keychainObject, encoding: .utf8)!
 print(accessToken)
 }
*/
class LoginHelper: ObservableObject {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("loggedInUsersList") var loggedInUsersList = Settings.loggedInUsersList
  @AppStorage("loggedInEmailsList") var loggedInEmailsList = Settings.loggedInEmailsList
  @Published var usernameEmail: String
  @Published var password: String
  @Published var twoFactor: String?

  /// Initially twoFactor is set to nil, then twoFactor is passed in if it's required
  init(usernameEmail: String, password: String, twoFactor: String?) {
    self.usernameEmail = usernameEmail
    self.password = password
    self.twoFactor = twoFactor
  }

  func login(completion: @escaping (Bool, String) -> Void) {
    let endpoint = "https://\(selectedInstance)/api/v3/user/login"
    let credentialsRequest = CredentialsRequestModel(
      username_or_email: usernameEmail,
      password: password,
      totp_2fa_token: twoFactor == "" ? nil : twoFactor  // skipcq: SW-P1006
    )

    let headers: HTTPHeaders = [
      "accept": "application/json",
      "Content-Type": "application/json",
    ]

    AF.request(
      endpoint,
      method: .post,
      parameters: credentialsRequest,
      encoder: JSONParameterEncoder.default,
      headers: headers
    )
    .responseDecodable(of: CredentialsResponseModel.self) { response in
      switch response.result {
      case let .success(fetchedData):
        self.handleLoginSuccess(fetchedData: fetchedData)
        completion(true, "LOGIN_SUCCESS")

      case let .failure(error):
        if let data = response.data,
          let loginErrorResponse = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          completion(false, loginErrorResponse.error)

        } else {
          // Handle JSON decoding errors
          print(
            "LoginHelper JSON DECODE ERROR: \(error): \(String(describing: error.errorDescription))"
          )
          completion(false, "JSON_DECODE_ERROR")
        }
      }
    }
  }

  /// The UsernameEmailFetcher class will return both an Email and a Username given a JWT
  /// They will be tracked in @AppStorage arrays
  /// There are 2 @AppStorage arrays: Logged in Emails, and Logged in Usernames
  /// Usernames sometimes users won't have an email (which is ok)
  /// Then write the JWT to keychain using Username as the Key
  func handleLoginSuccess(fetchedData: CredentialsResponseModel) {
    print("login successful inside handleLoginSuccess()")
    let jwt = fetchedData.jwt
    SiteInfoFetcher(jwt: jwt).fetchSiteInfo { username, email, actorID, _ in

      if let validActorID = actorID {
        self.loggedInUsersList.append(validActorID)
        KeychainHelper.standard.save(jwt, service: self.appBundleID, account: validActorID)
      }
      if let validEmail = email {
        self.loggedInEmailsList.append(validEmail)
      }
    }
  }
}

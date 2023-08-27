//
//  SiteInfoFetcher.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

class SiteInfoFetcher: ObservableObject {
  private var jwt: String
  private var endpoint: URLComponents

  /// Adding info about the user to **@AppsStorage** loggedInAccounts
  var loggedInAccount = LoggedInAccount()
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

  init(jwt: String) {
    self.jwt = jwt
    endpoint = URLBuilder(endpointPath: "/api/v3/site", jwt: jwt).buildURL()
  }

  func fetchSiteInfo(completion: @escaping (String?, String?, String?, String?) -> Void) {
    AF.request(endpoint)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: SiteModel.self) { response in
        switch response.result {
        case let .success(result):
          let userID = result.myUser.localUserView.person.id
          let username = result.myUser.localUserView.person.name
          let email = result.myUser.localUserView.localUser.email
          let avatarURL = result.myUser.localUserView.person.avatar
          let actorID = result.myUser.localUserView.person.actorID
          /// creating a loggedinuser object that can be persisted
          self.loggedInAccount.userID = String(userID)
          self.loggedInAccount.name = username ?? URLParser.extractUsername(from: actorID)
          self.loggedInAccount.email = email
          self.loggedInAccount.avatarURL = avatarURL ?? ""
          self.loggedInAccount.actorID = actorID
          /// adding to the list of already logged in accounts
          self.loggedInAccounts.append(self.loggedInAccount)
          /// Selecting and setting the latest logged in account as active
          self.selectedName = username ?? URLParser.extractUsername(from: actorID)
          self.selectedEmail = email
          self.selectedAvatarURL = avatarURL ?? ""
          self.selectedActorID = actorID

          let response = String(response.response?.statusCode ?? 0)

          completion(username, email, actorID, response)

        /// This function would only trigger if login was a success,
        /// so here you only really need to return api, internet, and json decode errors
        case let .failure(error):
          if let data = response.data,
            let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
          {
            print("fetchUsernameAndEmail ERROR: \(fetchError.error)")
            completion(nil, nil, nil, fetchError.error)
          } else {
            let errorDescription = String(describing: error.errorDescription)
            print("fetchUsernameAndEmail JSON DECODE ERROR: \(error): \(errorDescription)")
            completion(nil, nil, nil, error.errorDescription)
          }
        }
      }
  }
}

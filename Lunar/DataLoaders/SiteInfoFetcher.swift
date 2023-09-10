//
//  SiteInfoFetcher.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Alamofire
import Foundation
import Pulse
import SwiftUI

class SiteInfoFetcher: ObservableObject {
  private var endpoint: URLComponents
  private var endpointRedacted: URLComponents
  private var jwt: String

  /// Adding info about the user to **@AppsStorage** loggedInAccounts
  var loggedInAccount = AccountModel()
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("selectedUser") var selectedUser = Settings.selectedUser
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled

  let pulse = Pulse.LoggerStore.shared

  init(jwt: String) {
    self.jwt = jwt
    endpoint = URLBuilder(endpointPath: "/api/v3/site", jwt: jwt).buildURL()
    endpointRedacted = URLBuilder(endpointPath: "/api/v3/site").buildURL()
  }

  func fetchSiteInfo(completion: @escaping (String?, String?, String?, String?) -> Void) {
    AF.request(endpoint)
      .validate(statusCode: 200 ..< 300)
      .responseDecodable(of: SiteModel.self) { response in

        if self.networkInspectorEnabled {
          self.pulse.storeRequest(
            try! URLRequest(url: self.endpointRedacted, method: .get),
            response: response.response,
            error: response.error,
            data: response.data
          )
        }

        switch response.result {
        case let .success(result):
          
          let userID = result.myUser.localUserView.person.id
          self.loggedInAccount.userID = String(userID ?? 0)
          
          let username = result.myUser.localUserView.person.name
          self.loggedInAccount.name = username
          
          let email = result.myUser.localUserView.localUser.email
          self.loggedInAccount.email = email ?? ""
          
          let avatarURL = result.myUser.localUserView.person.avatar
          self.loggedInAccount.avatarURL = avatarURL ?? ""
          
          let actorID = result.myUser.localUserView.person.actorID
          self.loggedInAccount.actorID = actorID
          
          let displayName = result.myUser.localUserView.person.displayName
          self.loggedInAccount.displayName = displayName ?? username
          
          let postScore = result.myUser.localUserView.counts.postScore
          self.loggedInAccount.postScore = postScore ?? 0
          
          let commentScore = result.myUser.localUserView.counts.commentScore
          self.loggedInAccount.commentScore = commentScore ?? 0
          
          let postCount = result.myUser.localUserView.counts.postCount
          self.loggedInAccount.postCount = postCount ?? 0
          
          let commentCount = result.myUser.localUserView.counts.commentCount
          self.loggedInAccount.commentCount = commentCount ?? 0
          
          let response = String(response.response?.statusCode ?? 0)
          
          for account in self.loggedInAccounts {
            if actorID == account.actorID {
              completion(nil, nil, nil, nil)
            }
          }
          
          self.loggedInAccounts.append(self.loggedInAccount)
          self.selectedUser = [self.loggedInAccount]
          self.selectedActorID = actorID
          self.selectedAvatarURL = avatarURL ?? ""
          self.selectedEmail = email ?? ""
          self.selectedName = username
              
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
            print("fetchUsernameAndEmail JSON DECODE ERROR: \(error): \(String(describing: error.errorDescription))")
            completion(nil, nil, nil, error.errorDescription)
          }
        }
      }
  }
}

//
//  SiteInfoFetcher.swift
//  Lunar
//
//  Created by Mani on 30/07/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class SiteInfoFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.loggedInAccounts) var loggedInAccounts

  private var jwt: String

  let widgetLink = WidgetLink()

  var loggedInAccount = AccountModel()

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: "/api/v3/site",
      jwt: jwt
    )
  }

  init(jwt: String) {
    self.jwt = jwt
  }

  func fetchSiteInfo(completion: @escaping (String?, String?, String?, String?) -> Void) {
    AF.request(
      EndpointBuilder(parameters: parameters).build(),
      headers: GenerateHeaders().generate(jwt: jwt)
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: SiteModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

        if let myUser = result.myUser {
          let userID = myUser.localUserView.person.id
          self.loggedInAccount.userID = String(userID ?? 0)

          let username = myUser.localUserView.person.name
          self.loggedInAccount.name = username

          let email = myUser.localUserView.localUser.email
          self.loggedInAccount.email = email ?? ""

          let avatarURL = myUser.localUserView.person.avatar
          self.loggedInAccount.avatarURL = avatarURL ?? ""

          let actorID = myUser.localUserView.person.actorID
          self.loggedInAccount.actorID = actorID

          let displayName = myUser.localUserView.person.displayName
          self.loggedInAccount.displayName = displayName ?? username

          let postScore = myUser.localUserView.counts.postScore
          self.loggedInAccount.postScore = postScore ?? 0

          let commentScore = myUser.localUserView.counts.commentScore
          self.loggedInAccount.commentScore = commentScore ?? 0

          let postCount = myUser.localUserView.counts.postCount
          self.loggedInAccount.postCount = postCount ?? 0

          let commentCount = myUser.localUserView.counts.commentCount
          self.loggedInAccount.commentCount = commentCount ?? 0
          let response = String(response.response?.statusCode ?? 0)

          var foundMatch = false

          for account in self.loggedInAccounts {
            if actorID == account.actorID {
              foundMatch = true
              //              completion(nil, nil, nil, nil)
              break // Exit the loop early since a match was found
            }
          }

          // Example of loading an image based on a key
          ImageDownloadManager(suiteName: "group.io.github.mani-sh-reddy.Lunar")
            .loadImage(forKey: actorID.replacingOccurrences(of: "/", with: "_")) { _ in
            }

          if let avatarURL {
            self.storeUserAvatarToDisk(
              avatarURL: avatarURL,
              suiteName: "group.io.github.mani-sh-reddy.Lunar",
              imageKey: actorID
                .replacingOccurrences(of: "/", with: "_")
            )
          }

          if !foundMatch {
            self.loggedInAccounts.append(self.loggedInAccount)
            self.activeAccount = self.loggedInAccount
            self.widgetLink.storeAccountData(account: self.activeAccount)
            self.widgetLink.reloadWidget(kind: "AccountWidget")

            completion(username, email, actorID, response)
          }
        } else {
          completion(nil, nil, nil, "myUser not found")
          print("Error getting myUser info from SiteInfoFetcher")
        }

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

  func storeUserAvatarToDisk(avatarURL: String, suiteName: String, imageKey: String) {
    let imageDownloadManager = ImageDownloadManager(suiteName: suiteName)
    if let imageURL = URL(string: avatarURL) {
      imageDownloadManager.storeImage(fromURL: imageURL, forKey: imageKey) { success in
        if success {
          print("Image stored successfully. \(imageKey)")
        } else {
          print("Failed to store the image.")
        }
      }
    }
  }
}

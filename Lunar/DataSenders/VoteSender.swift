//
//  VoteSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Foundation
import SwiftUI

class VoteSender: ObservableObject {
  //  private var endpoint: URLComponents
  /// upvote = 1
  /// downvote = -1
  /// remove vote = 0
  private var voteType: Int
  private var postID: Int
  private var asActorID: String
  private var jwt: String = ""

  /// Adding info about the user to **@AppsStorage** loggedInAccounts
  var loggedInAccount = LoggedInAccount()
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL

  init(
    asActorID: String,
    voteType: Int,
    postID: Int,
    elementType: String
  ) {
    // TODO get the jwt from keychain using the actor id
    self.asActorID = asActorID
    self.voteType = voteType
    self.postID = postID
    //    self.endpoint = URLComponents()
    self.jwt = getJWTFromKeychain(actorID: asActorID) ?? ""
  }

  func fetchVoteInfo(completion: @escaping (Int?, Bool, String?) -> Void) {
    let parameters =
      [
        "score": voteType,
        "post_id": postID,
        "auth": jwt.replacingOccurrences(of: "\"", with: ""),
      ] as [String: Any]
    AF.request(
      "https://\(instanceHostURL)/api/v3/post/like",
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate(statusCode: 200..<300)
    .responseDecodable(of: VoteResponseModel.self) { response in
      print(response.request ?? "")
      switch response.result {
      case let .success(result):
        let response = String(response.response?.statusCode ?? 0)
        let voteSubmittedSuccessfully = self.voteType == result.post.myVote
        let postID = result.post.post.id

        completion(postID, voteSubmittedSuccessfully, response)

      case let .failure(error):
        if let data = response.data,
          let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("voteSender ERROR: \(fetchError.error)")
          completion(nil, false, fetchError.error)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("voteSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(nil, false, error.errorDescription)
        }
      }
    }
  }
  func getJWTFromKeychain(actorID: String) -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: self.appBundleID, account: actorID)
    {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt
    } else {
      return nil
    }
  }
}

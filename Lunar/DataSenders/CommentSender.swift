//
//  CommentSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Foundation
import SwiftUI

class CommentSender: ObservableObject {
  private var content: String
  private var postID: Int
  private var parentID: Int?
  private var jwt: String = ""

  /// Adding info about the user to **@AppsStorage** loggedInAccounts
  var loggedInAccount = AccountModel()
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance

  init(
    content: String,
    postID: Int,
    parentID: Int?
  ) {
    self.content = content
    self.postID = postID
    self.parentID = parentID
    self.jwt = getJWTFromKeychain(actorID: selectedActorID) ?? ""
  }

  func fetchCommentResponse(completion: @escaping (String?) -> Void) {
    let parameters =
      [
        "content": content,
        "post_id": postID,
        "parent_id": parentID as Any,
        "auth": jwt.replacingOccurrences(of: "\"", with: ""),
      ] as [String: Any]

    AF.request(
      "https://\(URLParser.extractDomain(from: selectedActorID))/api/v3/comment",
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommentResponseModel.self) { response in
      switch response.result {
      case let .success(result):
        print(result.comment.creator.name as Any)
        completion("success")

      case let .failure(error):
        if let data = response.data,
          let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("subscriptionActionSender ERROR: \(fetchError.error)")
          completion(fetchError.error)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("subscriptionActionSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(error.errorDescription)
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

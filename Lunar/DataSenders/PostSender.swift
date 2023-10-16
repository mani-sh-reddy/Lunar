//
//  PostSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class PostSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  private var communityID: Int
  private var postName: String
  private var postURL: String
  private var postBody: String

  private var jwt: String = ""

  let pulse = Pulse.LoggerStore.shared

  init(
    communityID: Int,
    postName: String,
    postURL: String,
    postBody: String
  ) {
    self.communityID = communityID
    self.postName = postName
    self.postURL = postURL
    self.postBody = postBody
    jwt = getJWTFromKeychain(actorID: activeAccount.actorID) ?? ""
  }

  func fetchPostSentResponse(completion: @escaping (String?, Int) -> Void) {
    var parameters =
      [
        "name": postName,
        "community_id": communityID,
        "auth": jwt,
      ] as [String: Any]

    if !postURL.isEmpty { parameters["url"] = String(postURL) }
    if !postBody.isEmpty { parameters["body"] = String(postBody) }

    let endpoint = "https://\(URLParser.extractDomain(from: activeAccount.actorID))/api/v3/post"

    AF.request(
      endpoint,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CreatePostResponseModel.self) { response in

      if self.networkInspectorEnabled {
        self.pulse.storeRequest(
          response.request ?? URLRequest(url: URL(string: endpoint)!),
          response: response.response,
          error: response.error,
          data: response.data
        )
      }

      switch response.result {
      case let .success(result):
        let postID = Int(result.post?.post.id ?? 0)
        print(String(postID))
        completion("success", postID)

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("CreateNewPost ERROR: \(fetchError.error)")
          completion(fetchError.error, 0)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("CreateNewPost JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(error.errorDescription, 0)
        }
      }
    }
  }

  func getJWTFromKeychain(actorID: String) -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

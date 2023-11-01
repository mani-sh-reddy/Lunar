//
//  CommentSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class CommentSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  private var content: String
  private var postID: Int
  private var parentID: Int?
  private var jwt: String = ""

  let pulse = Pulse.LoggerStore.shared

  init(
    content: String,
    postID: Int,
    parentID: Int?
  ) {
    self.content = content
    self.postID = postID
    self.parentID = parentID
    jwt = getJWTFromKeychain(actorID: activeAccount.actorID) ?? ""
  }

  func fetchCommentResponse(completion: @escaping (String?) -> Void) {
    let parameters =
      [
        "content": content,
        "post_id": postID,
        "parent_id": parentID as Any,
        "auth": jwt,
      ] as [String: Any]

    let endpoint = "https://\(URLParser.extractDomain(from: activeAccount.actorID))/api/v3/comment"

    AF.request(
      endpoint,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate(statusCode: 200 ..< 300)
    // URLRequest(url: endpoint, method: .post)
    .responseDecodable(of: CommentResponseModel.self) { response in

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
        print(result.comment.creator.name as Any)
        completion("success")

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("commentSender ERROR: \(fetchError.error)")
          completion(fetchError.error)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("commentSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(error.errorDescription)
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

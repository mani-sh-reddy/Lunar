//
//  VoteSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Foundation
import SwiftUI
import Pulse

class VoteSender: ObservableObject {
  private var voteType: Int
  private var postID: Int
  private var commentID: Int
  private var jwt: String = ""
  private var elementType: String = ""

  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled
  
  let pulse = Pulse.LoggerStore.shared

  init(
    asActorID: String,
    voteType: Int,
    postID: Int,
    commentID: Int,
    elementType: String
  ) {
    self.voteType = voteType
    self.postID = postID
    self.commentID = commentID
    self.elementType = elementType
    jwt = getJWTFromKeychain(actorID: asActorID) ?? ""
  }

  func fetchVoteInfo(completion: @escaping (Int?, Bool, String?) -> Void) {
    let parameters =
      [
        "score": voteType,
        "post_id": postID,
        "comment_id": commentID,
        "auth": jwt.replacingOccurrences(of: "\"", with: ""),
      ] as [String: Any]
    
    let endpoint = "https://\(URLParser.extractDomain(from: selectedActorID))/api/v3/\(elementType)/like"

    AF.request(
      endpoint,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: VoteResponseModel.self) { response in
      
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
        let response = String(response.response?.statusCode ?? 0)
        if self.elementType == "post" {
          let voteSubmittedSuccessfully = self.voteType == result.post?.myVote
          let elementID = result.post?.post.id
          completion(elementID, voteSubmittedSuccessfully, response)
        } else if self.elementType == "comment" {
          let voteSubmittedSuccessfully = self.voteType == result.comment?.myVote
          let elementID = result.comment?.comment.id
          completion(elementID, voteSubmittedSuccessfully, response)
        } else {
          completion(nil, false, response)
        }

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
      service: appBundleID, account: actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt
    } else {
      return nil
    }
  }
}

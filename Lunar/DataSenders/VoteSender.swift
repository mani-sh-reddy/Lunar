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
  private var communityActorID: String
  private var commentID: Int
  private var elementID: Int
  private var asActorID: String
  private var jwt: String = ""
  private var elementType: String = ""

  /// Adding info about the user to **@AppsStorage** loggedInAccounts
  var loggedInAccount = LoggedInAccount()
  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance

  init(
    asActorID: String,
    voteType: Int,
    postID: Int,
    communityActorID: String,
    commentID: Int,
    elementType: String
  ) {
    self.asActorID = asActorID
    self.voteType = voteType
    self.postID = postID
    self.communityActorID = communityActorID
    self.commentID = commentID
    self.elementType = elementType
    //    self.endpoint = URLComponents()
    self.elementID = 0
    self.jwt = getJWTFromKeychain(actorID: asActorID) ?? ""
  }

  func fetchVoteInfo(completion: @escaping (Int?, Bool, String?) -> Void) {
    let parameters =
      [
        "score": voteType,
        "post_id": postID,
        "comment_id": commentID,
        "auth": jwt.replacingOccurrences(of: "\"", with: ""),
      ] as [String: Any]
    //    let headers: HTTPHeaders = ["Referer": "https://lemmy.world/c/programmer_humor@programming.dev"]
    //    let headers: HTTPHeaders = ["Referer": generateReferer(
    //      selectedActorID: selectedActorID,
    //      communityActorID: communityActorID
    //    ) ]
    AF.request(
      "https://\(URLParser.extractDomain(from: selectedActorID))/api/v3/\(elementType)/like",
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default
        //      headers: headers
    )
    .validate(statusCode: 200..<300)
    .responseDecodable(of: VoteResponseModel.self) { response in
      print(response.request ?? "")
      print(response.request?.headers as Any)
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

      //        completion(elementID, voteSubmittedSuccessfully, response)

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

  func generateReferer(selectedActorID: String, communityActorID: String) -> String {
    let userSplit = splitURL(selectedActorID)
    let communitySplit = splitURL(communityActorID)

    let userDomain = String(describing: userSplit.1)
    let community = String(describing: communitySplit.2)
    let communityDomain = String(describing: communitySplit.1)

    // https://lemmy.world/c/memes@lemmy.ml
    print("https://\(userDomain)/c/\(community)@\(communityDomain)")
    return "https://\(userDomain)/c/\(community)@\(communityDomain)"
  }

  func splitURL(_ url: String) -> (String?, String?, String?, String?) {
    guard let urlComponents = URLComponents(string: url),
      let host = urlComponents.host,
      let pathComponents = urlComponents.path.split(separator: "/").map(String.init) as? [String]
    else {
      return (nil, nil, nil, nil)
    }

    let scheme = urlComponents.scheme
    let domain = host
    let pathPart1 = pathComponents.count > 1 ? pathComponents[1] : nil
    let pathPart2 = pathComponents.count > 2 ? pathComponents[2] : nil

    //    print("-----------------")
    //    print(url as Any)
    //    print(scheme as Any)
    //    print(domain as Any)
    //    print(pathPart1 as Any)
    //    print(pathPart2 as Any)

    return (scheme, domain, pathPart1, pathPart2)
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

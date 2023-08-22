////
////  CommentSender.swift
////  Lunar
////
////  Created by Mani on 16/08/2023.
////
//
//import Alamofire
//import Foundation
//import SwiftUI
//
//class CommentSender: ObservableObject {
//  private var content: Int
//  private var postID: Int
//  private var parentID: Int?
//  private var jwt: String =  ""
//  
//  /// Adding info about the user to **@AppsStorage** loggedInAccounts
//  var loggedInAccount = LoggedInAccount()
//  @AppStorage("loggedInAccounts") var loggedInAccounts = Settings.loggedInAccounts
//  @AppStorage("selectedName") var selectedName = Settings.selectedName
//  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
//  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
//  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
//  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
//  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
//  
//  init(
//    communityID: Int,
//    asActorID: String,
//    subscribeAction: Bool
//  ) {
//    self.communityID = communityID
//    self.asActorID = asActorID
//    self.subscribeAction = subscribeAction
//    self.jwt = getJWTFromKeychain(actorID: asActorID) ?? ""
//  }
//  
//  func fetchSubscribeInfo(completion: @escaping (Int?, SubscribedState?, String?) -> Void) {
//    let parameters = [
//      "follow": subscribeAction,
//      "community_id": communityID,
//      "auth": jwt.replacingOccurrences(of: "\"", with: "")
//    ] as [String : Any]
//    
//    AF.request(
//      "https://\(URLParser.extractDomain(from: selectedActorID))/api/v3/community/follow",
//      method: .post,
//      parameters: parameters,
//      encoding: JSONEncoding.default
//    )
//    .validate(statusCode: 200..<300)
//    .responseDecodable(of: SubscribeResponseModel.self) { response in
//      print(response.request ?? "")
//      switch response.result {
//      case let .success(result):
//        print(result.community?.subscribed.rawValue ?? "NO VALUE")
//        let response = String(response.response?.statusCode ?? 0)
//        let subscribeResponse = result.community?.subscribed
//        let communityID = result.community?.community.id
//        
//        completion(communityID, subscribeResponse, response)
//        
//      case let .failure(error):
//        if let data = response.data,
//           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
//        {
//          print("subscriptionActionSender ERROR: \(fetchError.error)")
//          completion(nil, nil, fetchError.error)
//        } else {
//          let errorDescription = String(describing: error.errorDescription)
//          print("subscriptionActionSender JSON DECODE ERROR: \(error): \(errorDescription)")
//          completion(nil, nil, error.errorDescription)
//        }
//      }
//    }
//  }
//  func getJWTFromKeychain(actorID: String) -> String? {
//    if let keychainObject = KeychainHelper.standard.read(service: self.appBundleID, account: actorID) {
//      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
//      return jwt
//    } else {
//      return nil
//    }
//  }
//}

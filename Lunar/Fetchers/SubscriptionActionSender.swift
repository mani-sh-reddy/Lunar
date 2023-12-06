//
//  SubscriptionActionSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class SubscriptionActionSender: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  private var communityID: Int
  private var subscribeAction: Bool
  private var jwt: String = ""

  let pulse = Pulse.LoggerStore.shared

  init(
    communityID: Int,
    asActorID: String,
    subscribeAction: Bool
  ) {
    self.communityID = communityID
    self.subscribeAction = subscribeAction
    jwt = getJWTFromKeychain(actorID: asActorID) ?? ""
  }

  func fetchSubscribeInfo(completion: @escaping (Int?, SubscribedState?, String?) -> Void) {
    let parameters =
      [
        "follow": subscribeAction,
        "community_id": communityID,
        "auth": jwt,
      ] as [String: Any]

    var headers: HTTPHeaders = []
    if !jwt.isEmpty {
      headers = [.authorization(bearerToken: jwt)]
    }

    let endpoint = "https://\(URLParser.extractDomain(from: activeAccount.actorID))/api/v3/community/follow"

    AF.request(
      endpoint,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: headers
    )
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: SubscribeResponseModel.self) { response in

      if self.networkInspectorEnabled {
        self.pulse.storeRequest(
          response.request ?? URLRequest(url: URL(string: endpoint)!),
          response: response.response,
          error: response.error,
          data: response.data
        )
      }

      print(response.request ?? "")
      switch response.result {
      case let .success(result):
        print(result.community?.subscribed.rawValue ?? "NO VALUE")
        let response = String(response.response?.statusCode ?? 0)
        let subscribeResponse = result.community?.subscribed
        let communityID = result.community?.community.id

        completion(communityID, subscribeResponse, response)

      case let .failure(error):
        if let data = response.data,
           let fetchError = try? JSONDecoder().decode(ErrorResponseModel.self, from: data)
        {
          print("subscriptionActionSender ERROR: \(fetchError.error)")
          completion(nil, nil, fetchError.error)
        } else {
          let errorDescription = String(describing: error.errorDescription)
          print("subscriptionActionSender JSON DECODE ERROR: \(error): \(errorDescription)")
          completion(nil, nil, error.errorDescription)
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

//
//  PrivateMessageFetcher.swift
//  Lunar
//
//  Created by Mani on 22/11/2023.
//

import Alamofire
import Combine
import Defaults
import Nuke
import Pulse
import RealmSwift
import SwiftUI

class PrivateMessageFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.postSort) var postSort
  @Default(.postType) var postType
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.selectedInstance) var selectedInstance

  @Published var isLoading = false

  let pulse = Pulse.LoggerStore.shared

//  var sort: String
//  var type: String
//  var communityID: Int?
//  var personID: Int?
  var instance: String
//  var filterKey: String
  var endpointPath: String = "/api/v3/private_message/list"

//  @State private var page: Int = 1

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      jwt: getJWTFromKeychain(),
      instance: instance
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      instance: instance
    ).buildURL()
  }

  init(
    instance: String
  ) {
    self.instance = instance
  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    var headers: HTTPHeaders = []
    if let jwt = getJWTFromKeychain() {
      headers = [.authorization(bearerToken: jwt)]
    }

    print("_____________FETCH_TRIGGERED_____________")
    AF.request(endpoint, headers: headers) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PrivateMessageModel.self) { response in
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

        // MARK: - Realm

        let realm = try! Realm()

        try! realm.write {
          for message in result.privateMessages {
            let realmPrivateMessage = RealmPrivateMessage(
              messageID: message.privateMessage.id,
              messageContent: message.privateMessage.content,
              messageDeleted: message.privateMessage.deleted,
              messageRead: message.privateMessage.deleted,
              messagePublished: message.privateMessage.published,
              messageApID: message.privateMessage.apID,
              messageIsLocal: message.privateMessage.local,
              creatorID: message.creator.id ?? 0,
              creatorName: message.creator.name,
              creatorAvatar: message.creator.avatar ?? "",
              creatorActorID: message.creator.actorID,
              recipientID: message.recipient.id ?? 0,
              recipientName: message.recipient.name,
              recipientAvatar: message.recipient.avatar ?? "",
              recipientActorID: message.recipient.actorID
            )
            realm.add(realmPrivateMessage, update: .modified)
          }
        }
        self.isLoading = false

      case let .failure(error):
        print("PrivateMessageFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        self.isLoading = false
      }
    }
  }

  func getJWTFromKeychain() -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: activeAccount.actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

//
//  CommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Defaults
import Foundation
import Nuke
import Pulse
import RealmSwift
import SwiftUI

class CommunitiesFetcher: ObservableObject {
  @Default(.communitiesSort) var communitiesSort
  @Default(.communitiesType) var communitiesType
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  private var currentPage = 1
  private var sortParameter: String?
  private var typeParameter: String?
  private var limitParameter: Int = 50
  private var communityID: Int?
  private var jwt: String?
  var instance: String?

  private var endpointPath: String {
    if communityID != nil {
      "/api/v3/community"
    } else {
      "/api/v3/community/list"
    }
  }

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      communityID: communityID,
      jwt: jwt,
      instance: instance
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      communityID: communityID,
      instance: instance
    ).buildURL()
  }

  let pulse = Pulse.LoggerStore.shared

  init(
    limitParameter: Int,
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    instance: String? = nil
  ) {
    self.sortParameter = sortParameter ?? communitiesSort
    self.typeParameter = typeParameter ?? communitiesType
    self.limitParameter = limitParameter

    /// Force an instance if it's different to the one you want
    self.instance = instance

    jwt = getJWTFromKeychain(actorID: activeAccount.actorID) ?? ""
  }

  func loadContent(isRefreshing _: Bool = false) {
    let cacher = ResponseCacher(behavior: .cache)

    var headers: HTTPHeaders = []
    if let jwt {
      headers = [.authorization(bearerToken: jwt)]
    }

    AF.request(endpoint, headers: headers) { urlRequest in
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CommunityModel.self) { response in

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

        print(result.communities.count)

        let imagesToPrefetch = result.iconURLs.compactMap { URL(string: $0) }
        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        let realm = try! Realm()

        try! realm.write {
          for community in result.communities {
            let fetchedCommunity = RealmCommunity(
              id: community.community.id,
              name: community.community.name,
              title: community.community.title,
              actorID: community.community.actorID,
              instanceID: community.community.instanceID,
              descriptionText: community.community.description,
              icon: community.community.icon,
              banner: community.community.banner,
              postingRestrictedToMods: community.community.postingRestrictedToMods,
              published: community.community.published,
              subscribers: community.counts.subscribers,
              posts: community.counts.posts,
              comments: community.counts.comments,
              subscribed: community.subscribed
            )
            realm.add(fetchedCommunity, update: .modified)
          }
        }

      case let .failure(error):
        print("CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")")
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

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
  var instance: String?

  private var endpointPath: String {
    if communityID != nil {
      "/api/v3/community"
    } else {
      "/api/v3/community/list"
    }
  }

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: endpointPath,
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      communityID: communityID,
      jwt: JWT().getJWTForActiveAccount(),
      instance: instance
    )
  }

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
  }

  func loadContent(isRefreshing _: Bool = false) {
    let cacher = ResponseCacher(behavior: .cache)

    AF.request(
      EndpointBuilder(parameters: parameters).build(),
      headers: GenerateHeaders().generate()
    ) { urlRequest in
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CommunityModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

        print(result.communities.count)

        let imagesToPrefetch = result.iconURLs.compactMap { URL(string: $0) }
        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        RealmWriter().writeCommunity(communities: result.communities)

      case let .failure(error):
        print("CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }
}

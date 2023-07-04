//
//  LegacyCommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Defaults
import Foundation
import Nuke
import Pulse
import SwiftUI

class LegacyCommunitiesFetcher: ObservableObject {
  @Default(.communitiesSort) var communitiesSort
  @Default(.communitiesType) var communitiesType
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.legacyHiddenCommunitiesList) var legacyHiddenCommunitiesList

  @Published var communities = [CommunityObject]()
  @Published var isLoading = false

  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  private var currentPage = 1
  var sortParameter: String?
  var typeParameter: String?
  var limitParameter: Int = 50
  var communityID: Int?

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
      jwt: JWT().getJWTForActiveAccount()
    )
  }

  let pulse = Pulse.LoggerStore.shared

  init(
    limitParameter: Int,
    sortParameter: String? = nil,
    typeParameter: String? = nil
  ) {
    self.sortParameter = sortParameter ?? communitiesSort
    self.typeParameter = typeParameter ?? communitiesType
    self.limitParameter = limitParameter
    loadContent()
  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    if isRefreshing {
      currentPage = 1
    } else {
      isLoading = true
    }

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(
      EndpointBuilder(parameters: parameters).build(),
      headers: GenerateHeaders().generate()
    ) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CommunityModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

        let fetchedCommunities = result.communities.filter {
          !self.legacyHiddenCommunitiesList.contains($0.community.actorID)
        }

        let imagesToPrefetch = result.iconURLs.compactMap { URL(string: $0) }
        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        if isRefreshing {
          self.communities = fetchedCommunities
        } else {
          /// Removing duplicates
          let filteredCommunities = fetchedCommunities.filter { community in
            !self.communities.contains { $0.community.id == community.community.id }
          }
          self.communities += filteredCommunities
          self.currentPage += 1
        }
        if !isRefreshing {
          self.isLoading = false
        }

      case let .failure(error):
        print("CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        if !isRefreshing {
          self.isLoading = false
        }
      }
    }
  }
}

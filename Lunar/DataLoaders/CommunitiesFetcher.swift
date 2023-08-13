//
//  CommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

@MainActor class CommunitiesFetcher: ObservableObject {
  @AppStorage("communitiesSort") var communitiesSort = Settings.communitiesSort
  @AppStorage("communitiesType") var communitiesType = Settings.communitiesType

  @Published var communities = [CommunityElement]()
  @Published var isLoading = false

  private var currentPage = 1
  private var sortParameter: String?
  private var typeParameter: String?
  private var limitParameter: Int = 30
  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/community/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter
    ).buildURL()
  }

  init(
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    limitParameter: Int
  ) {
    self.sortParameter = sortParameter ?? communitiesSort
    self.typeParameter = typeParameter ?? communitiesType
    self.limitParameter = limitParameter
    loadMoreContent()
  }

  func refreshContent() async {
    do {
      try await Task.sleep(nanoseconds: 1_000_000_000)
    } catch {}

    guard !isLoading else { return }

    isLoading = true

    currentPage = 1

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      print("CommunitiesFetcher REF \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .reloadRevalidatingCacheData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommunityModel.self) { response in
      switch response.result {
      case let .success(result):
        let newCommunities = result.communities
        let filteredNewCommunities = newCommunities.filter { newCommunity in
          !self.communities.contains { $0.community.id == newCommunity.community.id }
        }

        self.communities.insert(contentsOf: filteredNewCommunities, at: 0)

        self.isLoading = false

        let cachableImageURLs = result.iconURLs.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
        prefetcher.start()

      case let .failure(error):
        print("CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }

  func loadMoreContentIfNeeded(currentItem community: CommunityElement?) {
    guard let community else {
      loadMoreContent()
      return
    }
    let thresholdIndex = communities.index(communities.endIndex, offsetBy: -20)
    if communities.firstIndex(where: { $0.community.id == community.community.id })
      == thresholdIndex
    {
      loadMoreContent()
    }
  }

  private func loadMoreContent() {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      print("CommunitiesFetcher LOAD \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommunityModel.self) { response in
      switch response.result {
      case let .success(result):

        let newCommunities = result.communities

        let filteredNewCommunities = newCommunities.filter { newCommunities in
          !self.communities.contains { $0.community.id == newCommunities.community.id }
        }

        self.communities += filteredNewCommunities

        self.isLoading = false
        self.currentPage += 1

      case let .failure(error):
        print("CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }
}

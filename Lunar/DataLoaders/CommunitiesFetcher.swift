//
//  CommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import SwiftUI
import Pulse

@MainActor class CommunitiesFetcher: ObservableObject {
  @AppStorage("communitiesSort") var communitiesSort = Settings.communitiesSort
  @AppStorage("communitiesType") var communitiesType = Settings.communitiesType
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled
  @AppStorage("logs") var logs = Settings.logs

  @Published var communities = [CommunityObject]()
  @Published var isLoading = false

  private var currentPage = 1
  private var sortParameter: String?
  private var typeParameter: String?
  private var limitParameter: Int = 30
  private var communityID: Int?
  private var jwt: String?

  private var endpointPath: String {
    if communityID != nil {
      return "/api/v3/community"
    } else {
      return "/api/v3/community/list"
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
      jwt: jwt
    ).buildURL()
  }
  
  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      communityID: communityID
    ).buildURL()
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
    jwt = getJWTFromKeychain(actorID: selectedActorID) ?? ""
    loadMoreContent()
  }

  func refreshContent() async {
    guard !isLoading else { return }

    isLoading = true
    communities.removeAll()

    currentPage = 1

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      print("CommunitiesFetcher REF - hidden url due to jwt \(urlRequest)")
      urlRequest.cachePolicy = .reloadRevalidatingCacheData
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
        let newCommunities = result.communities
        let filteredNewCommunities = newCommunities.filter { newCommunity in
          !self.communities.contains { $0.community.id == newCommunity.community.id }
        }

        self.communities.insert(contentsOf: filteredNewCommunities, at: 0)

        self.isLoading = false

      case let .failure(error):
        DispatchQueue.main.async {
          let log = "CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
        }
        self.isLoading = false
      }
      self.isLoading = false
    }
  }

  func loadMoreContentIfNeeded(currentItem community: CommunityObject?) {
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
      //      print("CommunitiesFetcher LOAD \(urlRequest.url as Any)")
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

        let newCommunities = result.communities

        let filteredNewCommunities = newCommunities.filter { newCommunities in
          !self.communities.contains { $0.community.id == newCommunities.community.id }
        }

        self.communities += filteredNewCommunities

        self.isLoading = false
        self.currentPage += 1

      case let .failure(error):
        DispatchQueue.main.async {
          let log = "CommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
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

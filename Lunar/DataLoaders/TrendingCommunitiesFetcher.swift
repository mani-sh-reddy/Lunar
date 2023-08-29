//
//  TrendingCommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

@MainActor class TrendingCommunitiesFetcher: ObservableObject {
  @Published var communities = [CommunityElement]()
  @Published var isLoading = false
  @AppStorage("enableLogging") var enableLogging = Settings.enableLogging
  @AppStorage("logs") var logs = Settings.logs
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance

  private var currentPage = 1
  private var limitParameter: Int = 5
  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/community/list",
      sortParameter: "Hot",
      typeParameter: "All",
      currentPage: currentPage,
      limitParameter: limitParameter
    ).buildURL()
  }

  init() {
    loadContent()
  }

  func refreshContent() async {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      let log = "TrendingCommunitiesFetcher REF \(urlRequest.url as Any)"
      print(log)
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommunityModel.self) { response in
      switch response.result {
      case let .success(result):
        self.communities = result.communities
        self.isLoading = false

      case let .failure(error):
        DispatchQueue.main.async {
          let log = "TrendingCommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
          self.isLoading = false
        }
      }
    }
    self.isLoading = false
  }

  private func loadContent() {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      let log = "TrendingCommunitiesFetcher LOAD \(urlRequest.url as Any)"
      print(log)
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommunityModel.self) { response in
      switch response.result {
      case let .success(result):
        self.communities = result.communities
        self.isLoading = false

      case let .failure(error):
        DispatchQueue.main.async {
          let log = "TrendingCommunitiesFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
        }
      }
    }
  }
}

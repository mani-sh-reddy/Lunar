//
//  PostsFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Nuke
import Pulse
import SwiftUI

@MainActor class PostsFetcher: ObservableObject {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("postSort") var postSort = Settings.postSort
  @AppStorage("postType") var postType = Settings.postType
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled

  @Published var posts = [PostObject]()
  @Published var isLoading = false

  let imagePrefetcher = ImagePrefetcher()
  
  let pulse = Pulse.LoggerStore.shared

  private var currentPage = 1
  private var sortParameter: String?
  private var typeParameter: String?
  private var communityID: Int?
  
  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      communityID: communityID,
      jwt: getJWTFromKeychain()
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      communityID: communityID
    ).buildURL()
  }

  init(
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    communityID: Int? = 0
  ) {
    self.sortParameter = sortParameter ?? postSort
    self.typeParameter = typeParameter ?? postType

    self.communityID = (communityID == 0) ? nil : communityID
    if communityID == 99999999999999 { // TODO: just a placeholder to prevent running when user posts
      return
    }

    loadContent()
  }

  func loadMoreContentIfNeeded(currentItem: PostObject) {
    guard currentItem.post.id == posts.last?.post.id else {
      return
    }
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
    
    AF.request(endpoint) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PostModel.self) { response in
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

        let fetchedPosts = result.posts
        
        let imageRequestList = result.imageURLs.compactMap {
          ImageRequest(url: URL(string: $0), processors: [.resize(width: 250)])
        }
        self.imagePrefetcher.startPrefetching(with: imageRequestList)

//        let imagesToPrefetch = result.imageURLs.compactMap { URL(string: $0) }
//        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        if isRefreshing {
          self.posts = fetchedPosts
        } else {
          /// Removing duplicates
          let filteredPosts = fetchedPosts.filter { post in
            !self.posts.contains { $0.post.id == post.post.id }
          }
          self.posts += filteredPosts
          self.currentPage += 1
        }
        if !isRefreshing {
          self.isLoading = false
        }
      case let .failure(error):
        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        if !isRefreshing {
          self.isLoading = false
        }
      }
    }
  }

  func getJWTFromKeychain() -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: selectedActorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

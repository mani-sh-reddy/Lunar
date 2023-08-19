//
//  PostsFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher
import SwiftUI

class PostsFetcher: ObservableObject {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("postSort") var postSort = Settings.postSort
  @AppStorage("postType") var postType = Settings.postType
  @Published var posts = [PostElement]()
  @Published var isLoading = false

  private var currentPage = 1
  private var sortParameter: String?
  private var typeParameter: String?
  private var communityID: Int?
  private var jwt: String = ""
  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 20,
      communityID: communityID,
      jwt: getJWTFromKeychain(actorID: selectedActorID) ?? ""
    ).buildURL()
  }

  private let fetchQueue = DispatchQueue(
    label: "com.example.fetchQueue", qos: .userInitiated, attributes: .concurrent)

  init(
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    communityID: Int? = 0
  ) {
    self.sortParameter = sortParameter ?? postSort
    self.typeParameter = typeParameter ?? postType

    self.communityID = (communityID == 0) ? nil : communityID
    if communityID == 99_999_999_999_999 {  // TODO just a placeholder to prevent running when user posts
      return
    }
    fetchQueue.async {
      self.loadMoreContent()
    }
  }

  func refreshContent() {
    guard !isLoading else { return }

    isLoading = true
    currentPage = 1

    fetchQueue.async {
      let cacher = ResponseCacher(behavior: .cache)
      AF.request(self.endpoint) { urlRequest in
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      }
      .cacheResponse(using: cacher)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: PostsModel.self) { response in
        switch response.result {
        case let .success(result):
          self.handleResponse(result: result)
        case let .failure(error):
          print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        }
      }
    }
  }

  func loadMoreContentIfNeeded(currentItem item: PostElement?) {
    guard let item else {
      loadMoreContent()
      return
    }
    /// preload early
    var thresholdIndex = posts.index(posts.endIndex, offsetBy: -10)
    if posts.firstIndex(where: { $0.post.id == item.post.id }) == thresholdIndex {
      loadMoreContent()
    }
    /// preload when reached the bottom
    thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)
    if posts.firstIndex(where: { $0.post.id == item.post.id }) == thresholdIndex {
      loadMoreContent()
    }
  }

  private func loadMoreContent() {
    guard !isLoading else { return }

    isLoading = true

    fetchQueue.async {
      let cacher = ResponseCacher(behavior: .cache)
      AF.request(self.endpoint) { urlRequest in
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      .cacheResponse(using: cacher)
      .validate(statusCode: 200..<300)
      .responseDecodable(of: PostsModel.self) { response in
        switch response.result {
        case let .success(result):
          self.handleResponse(result: result)
          self.currentPage += 1
        case let .failure(error):
          print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        }
      }
    }
  }

  private func handleResponse(result: PostsModel) {
    let newPosts = result.posts
    let filteredNewPosts = newPosts.filter { newPost in
      !self.posts.contains { $0.post.id == newPost.post.id }
    }

    let cachableImageURLs =
      result.thumbnailURLs.compactMap { URL(string: $0) }
      + result.avatarURLs.compactMap { URL(string: $0) }
    let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
    prefetcher.start()

    DispatchQueue.main.async {
      self.posts += filteredNewPosts
      self.isLoading = false
    }
  }

  func getJWTFromKeychain(actorID: String) -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: self.appBundleID, account: selectedActorID)
    {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

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

@MainActor class PostsFetcher: ObservableObject {
  @AppStorage("postSort") var postSort = Settings.postSort
  @AppStorage("postType") var postType = Settings.postType
  @Published var posts = [PostElement]()
  @Published var isLoading = false

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
      print("PostsFetcher REF \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .reloadRevalidatingCacheData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: PostsModel.self) { response in
      switch response.result {
      case let .success(result):

        let newPosts = result.posts

        let filteredNewPosts = newPosts.filter { newPost in
          !self.posts.contains { $0.post.id == newPost.post.id }
        }

        self.posts.insert(contentsOf: filteredNewPosts, at: 0)

        self.isLoading = false

        let cachableImageURLs =
          result.thumbnailURLs.compactMap { URL(string: $0) }
          + result.avatarURLs.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
        prefetcher.start()

      case let .failure(error):
        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }

  func loadMoreContentIfNeeded(currentItem item: PostElement?) {
    guard let item else {
      loadMoreContent()
      return
    }
    /// preload early
    var thresholdIndex = posts.index(posts.endIndex, offsetBy: -5)
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

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      print("PostsFetcher LOAD \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: PostsModel.self) { response in
      switch response.result {
      case let .success(result):
        let newPosts = result.posts

        let filteredNewPosts = newPosts.filter { newPost in
          !self.posts.contains { $0.post.id == newPost.post.id }
        }

        self.posts += filteredNewPosts
        self.isLoading = false
        self.currentPage += 1

      case let .failure(error):
        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }
}

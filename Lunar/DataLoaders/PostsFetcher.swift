//
//  PostsFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Nuke
import SwiftUI

@MainActor class PostsFetcher: ObservableObject {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("postSort") var postSort = Settings.postSort
  @AppStorage("postType") var postType = Settings.postType
  @AppStorage("logs") var logs = Settings.logs

  @Published var posts = [PostObject]()
  @Published var isLoading = false

  let imagePrefetcher = ImagePrefetcher()

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
//    print("\(posts.last?.post.id ?? 0) -> \(currentItem.post.id)")
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
      urlRequest.timeoutInterval = 5
      print(urlRequest.url ?? "")
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PostModel.self) { response in
      switch response.result {
      case let .success(result):

        let fetchedPosts = result.posts

        let imagesToPrefetch = result.imageURLs.compactMap { URL(string: $0) }
        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        if isRefreshing {
          self.posts = fetchedPosts
//          self.posts.insert(contentsOf: filteredNewPosts, at: 0)
        } else {
          /// Removing duplicates
          let filteredPosts = fetchedPosts.filter { post in
            !self.posts.contains { $0.post.id == post.post.id }
          }
          self.posts += filteredPosts
          self.currentPage += 1
        }
        if !isRefreshing{
          self.isLoading = false
        }
      case let .failure(error):
        DispatchQueue.main.async {
          let log = "PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
        }
        if !isRefreshing{
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

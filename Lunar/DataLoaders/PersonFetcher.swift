//
//  PersonFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Combine
import Defaults
import Nuke
import Pulse
import SwiftUI

class PersonFetcher: ObservableObject {
  @Default(.appBundleID) var appBundleID
  @Default(.activeAccount) var activeAccount
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

//  @Published var personModel = [PersonModel]()
  @Published var posts = [PostObject]()
  @Published var comments = [CommentObject]()
  @Published var isLoading = false

  let pulse = Pulse.LoggerStore.shared
  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  private var currentPage = 1
  var sortParameter: String?
  var typeParameter: String?
  var savedOnly: Bool?
  private var personID: Int
  private var instance: String?

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/user",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      savedOnly: savedOnly,
      personID: personID,
      jwt: getJWTFromKeychain(),
      instance: instance
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/user",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      savedOnly: savedOnly,
      personID: personID,
      instance: instance
    ).buildURL()
  }

  init(
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    savedOnly: Bool? = nil,
    personID: Int,
    instance: String? = nil
  ) {
    self.sortParameter = sortParameter
    self.typeParameter = typeParameter
    self.savedOnly = savedOnly

    self.personID = personID

    /// Can explicitly pass in an instance if it's different to the currently selected instance
    self.instance = instance

    loadContent()
  }

//  func loadMoreContentIfNeeded(currentItem: PostObject) {
//    guard currentItem.post.id == personModel.first?.posts.last?.post.id else {
//      return
//    }
//    loadContent()
//  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    if isRefreshing {
      currentPage = 1
    } else {
      isLoading = true
    }

    let cacher = ResponseCacher(behavior: .cache)

    var headers: HTTPHeaders = []
    if let jwt = getJWTFromKeychain() {
      headers = [.authorization(bearerToken: jwt)]
    }

    AF.request(endpoint, headers: headers) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PersonModel.self) { response in
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
        let fetchedComments = result.comments
//        self.personModel = [result]

        let imageRequestList = result.imageURLs.compactMap {
          ImageRequest(url: URL(string: $0), processors: [.resize(width: 200)])
        }
        self.imagePrefetcher.startPrefetching(with: imageRequestList)

//        let imagesToPrefetch = result.imageURLs.compactMap { URL(string: $0) }
//        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

        if isRefreshing {
          self.posts = fetchedPosts
          self.comments = fetchedComments
        } else {
          /// Removing duplicates
          let filteredPosts = fetchedPosts.filter { post in
            !self.posts.contains { $0.post.id == post.post.id }
          }
          let filteredComments = fetchedComments.filter { post in
            !self.comments.contains { $0.comment.id == post.comment.id }
          }
          self.posts += filteredPosts
          self.comments += filteredComments
          self.currentPage += 1
        }
        if !isRefreshing {
          self.isLoading = false
        }
      case let .failure(error):
        print("PersonFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        if !isRefreshing {
          self.isLoading = false
        }
      }
    }
  }

  func getJWTFromKeychain() -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: activeAccount.actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

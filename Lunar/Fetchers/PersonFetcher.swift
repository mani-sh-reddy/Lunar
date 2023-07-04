//
//  PersonFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Defaults
import Nuke
import SwiftUI

class PersonFetcher: ObservableObject {
  @Default(.appBundleID) var appBundleID
  @Default(.activeAccount) var activeAccount
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  @Published var posts = [PostObject]()
  @Published var comments = [CommentObject]()
  @Published var isLoading = false

  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  private var currentPage = 1
  var sortParameter: String?
  var typeParameter: String?
  var savedOnly: Bool?
  private var personID: Int
  private var instance: String?

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: "/api/v3/user",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      savedOnly: savedOnly,
      personID: personID,
      jwt: JWT().getJWTForActiveAccount(),
      instance: instance
    )
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

  func loadContent(isRefreshing: Bool = false) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {}
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
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PersonModel.self) { response in
      PulseWriter().write(response, self.parameters, .get)

      switch response.result {
      case let .success(result):

        let fetchedPosts = result.posts
        let fetchedComments = result.comments

        let imageRequestList = result.imageURLs.compactMap {
          ImageRequest(url: URL(string: $0), processors: [.resize(width: 200)])
        }
        self.imagePrefetcher.startPrefetching(with: imageRequestList)

        RealmWriter().writePost(
          posts: result.posts,
          sort: self.sortParameter ?? "",
          type: self.typeParameter ?? "",
          filterKey: self.savedOnly ?? false ? "MY_POSTS_SAVED_ONLY" : "MY_POSTS"
        )

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
}

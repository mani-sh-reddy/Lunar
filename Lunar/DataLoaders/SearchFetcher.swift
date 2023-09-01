//
//  SearchFetcher.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher
import SwiftUI

@MainActor class SearchFetcher: ObservableObject {
  @AppStorage("enableLogging") var enableLogging = Settings.enableLogging
  @AppStorage("logs") var logs = Settings.logs
  @Published var searchModel = [SearchModel]()

  @Published var comments = [CommentObject]()
  @Published var communities = [CommunityObject]()
  @Published var posts = [PostObject]()
  @Published var users = [PersonObject]()

  @Published var isLoading = false

  var searchQuery: String

  ///  Clear the current search list when making a new search
  ///  Defaults to false but will be set by the view
  var clearListOnChange: Bool

  private var currentPage = 1
  var typeParameter: String
  var sortParameter: String
  private var limitParameter: Int

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/search",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      searchQuery: searchQuery
    ).buildURL()
  }

  init(
    searchQuery: String,
    sortParameter: String,
    typeParameter: String,
    limitParameter: Int,
    clearListOnChange: Bool
  ) {
    self.searchQuery = searchQuery
    self.sortParameter = sortParameter
    self.typeParameter = typeParameter
    self.limitParameter = limitParameter
    self.clearListOnChange = clearListOnChange
    loadMoreContent { _, _ in }
  }

  func loadMoreCommentIfNeeded(currentItem comment: CommentObject?) {
    guard let comment else {
      loadMoreContent { _, _ in }
      return
    }
    let thresholdIndex = comments.index(comments.endIndex, offsetBy: -1)
    if comments.firstIndex(where: { $0.comment.id == comment.comment.id }) == thresholdIndex {
      loadMoreContent { _, _ in }
    }
  }

  func loadMoreCommunitiesIfNeeded(currentItem community: CommunityObject?) {
    guard let community else {
      loadMoreContent { _, _ in }
      return
    }
    let thresholdIndex = communities.index(communities.endIndex, offsetBy: -1)
    if communities.firstIndex(where: { $0.community.id == community.community.id })
      == thresholdIndex
    {
      loadMoreContent { _, _ in }
    }
  }

  func loadMorePostsIfNeeded(currentItem post: PostObject?) {
    guard let post else {
      loadMoreContent { _, _ in }
      return
    }
    let thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)
    if posts.firstIndex(where: { $0.post.id == post.post.id }) == thresholdIndex {
      loadMoreContent { _, _ in }
    }
  }

  func loadMoreUsersIfNeeded(currentItem user: PersonObject?) {
    guard let user else {
      loadMoreContent { _, _ in }
      return
    }
    let thresholdIndex = users.index(users.endIndex, offsetBy: -1)
    if users.firstIndex(where: { $0.person.id == user.person.id }) == thresholdIndex {
      loadMoreContent { _, _ in }
    }
  }

  func loadMoreContent(completion: @escaping (Bool, Error?) -> Void) {
    guard !isLoading else { return }

    if clearListOnChange {
      comments.removeAll()
      communities.removeAll()
      posts.removeAll()
      users.removeAll()
      currentPage = 1
    }

    print("SEARCH QUERY: \(searchQuery)")
    guard !searchQuery.isEmpty else {
      print("SEARCH QUERY EMPTY, RETURNING")
      return
    }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      let log = "SearchFetcher LOAD \(urlRequest.url as Any)"
      print(log)
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: SearchModel.self) { response in
      switch response.result {
      case let .success(result):
        self.appendToList(result)

        self.isLoading = false
        self.currentPage += 1
        completion(true, nil)

      case let .failure(error):
        DispatchQueue.main.async {
          let log = "SearchFetcher ERROR: \(error): \(error.errorDescription ?? "")"
          print(log)
          let currentDateTime = String(describing: Date())
          self.logs.append("\(currentDateTime) :: \(log)")
        }

        self.isLoading = false  // Set isLoading to false on failure as well
        completion(true, error)
      }
    }
  }

  private func appendToList(_ result: SearchModel) {
    // Check the typeParameter to determine which part of the code to execute
    switch self.typeParameter {
    case "Communities":
      let newCommunities = result.communities
      let filteredNewCommunities = newCommunities.filter { newCommunity in
        !self.communities.contains { $0.community.id == newCommunity.community.id }
      }
      self.communities += filteredNewCommunities
    case "Comments":
      let newComments = result.comments
      let filteredNewComments = newComments.filter { newComment in
        !self.comments.contains { $0.comment.id == newComment.comment.id }
      }
      self.comments += filteredNewComments
    case "Posts":
      let newPosts = result.posts
      let filteredNewPosts = newPosts.filter { newPost in
        !self.posts.contains { $0.post.id == newPost.post.id }
      }
      self.posts += filteredNewPosts
    case "Users":
      let newUsers = result.users
      let filteredNewUsers = newUsers.filter { newUser in
        !self.users.contains { $0.person.id == newUser.person.id }
      }
      self.users += filteredNewUsers
    default:
      print("break")
    }
  }

}

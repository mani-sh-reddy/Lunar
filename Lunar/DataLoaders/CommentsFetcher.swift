//
//  CommentsFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher
import SwiftUI

@MainActor class CommentsFetcher: ObservableObject {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("commentSort") var commentSort = Settings.commentSort
  @AppStorage("commentType") var commentType = Settings.commentType
  @Published var comments = [CommentElement]()
  @Published var isLoading = false

  private var currentPage = 1
  private var postID: Int
  private var limitParameter: Int = 50
  private let maxDepth: Int = 50
  private var jwt: String = ""

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/comment/list",
      sortParameter: commentSort,
      typeParameter: commentType,
      currentPage: currentPage,
      limitParameter: limitParameter,
      postID: postID,
      maxDepth: maxDepth,
      jwt: getJWTFromKeychain(actorID: selectedActorID) ?? ""
    ).buildURL()
  }

  init(postID: Int) {
    self.postID = postID
    loadMoreContent()
  }

  func refreshContent() async {
    comments.removeAll()
    guard !isLoading else { return }

    isLoading = true

    currentPage = 1

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      //      print("CommentsFetcher REF \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .reloadRevalidatingCacheData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommentModel.self) { response in
      switch response.result {
      case let .success(result):

        let newComments = result.comments

        let filteredNewComments = newComments.filter { newComments in
          !self.comments.contains { $0.comment.id == newComments.comment.id }
        }

        if !filteredNewComments.isEmpty {
          DispatchQueue.main.async {
            let sortedFilteredComments = filteredNewComments.sorted { sorted, newSorted in
              sorted.comment.path < newSorted.comment.path
            }
            for newComment in sortedFilteredComments {
              InsertSorter.sortComments(newComment, into: &self.comments)
            }
            self.isLoading = false
          }

        } else {
          self.isLoading = false
        }

      case let .failure(error):
        print("CommentsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }

  func loadMoreContentIfNeeded(currentItem comment: CommentElement?) {
    guard let comment else {
      loadMoreContent()
      return
    }
    let thresholdIndex = comments.index(comments.endIndex, offsetBy: 0)
    if comments.firstIndex(where: { $0.comment.id == comment.comment.id }) == thresholdIndex {
      loadMoreContent()
    }
  }

  private func loadMoreContent() {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    AF.request(endpoint) { urlRequest in
      //      print("CommentsFetcher LOAD \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .returnCacheDataElseLoad
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommentModel.self) { response in
      switch response.result {
      case let .success(result):

        let newComments = result.comments

        let filteredNewComments = newComments.filter { newComments in
          !self.comments.contains { $0.comment.id == newComments.comment.id }
        }

        if !filteredNewComments.isEmpty {
          DispatchQueue.main.async {
            let sortedFilteredComments = filteredNewComments.sorted { sorted, newSorted in
              sorted.comment.path < newSorted.comment.path
            }
            for newComment in sortedFilteredComments {
              InsertSorter.sortComments(newComment, into: &self.comments)
            }
            self.isLoading = false
          }

        } else {
          self.isLoading = false
        }

        self.currentPage += 1

      case let .failure(error):
        print("CommentsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
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
  func updateCommentCollapseState(_ comment: CommentElement, isCollapsed: Bool) {
    if let index = comments.firstIndex(where: { $0.comment.id == comment.comment.id }) {
      comments[index].isCollapsed = isCollapsed
    }
  }
  func updateCommentShrinkState(_ comment: CommentElement, isShrunk: Bool) {
    if let index = comments.firstIndex(where: { $0.comment.id == comment.comment.id }) {
      comments[index].isShrunk = isShrunk
    }
  }
}

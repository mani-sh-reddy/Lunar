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
  @Published var comments = [CommentElement]()
  @Published var isLoading = false

  private var currentPage = 1
  private var postID: Int
  private var sortParameter: String
  private var typeParameter: String
  private var limitParameter: Int = 50
  private let maxDepth: Int = 50
  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/comment/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: limitParameter,
      postID: postID,
      maxDepth: maxDepth
    ).buildURL()
  }

  init(
    postID: Int,
    sortParameter: String,
    typeParameter: String
  ) {
    self.postID = postID
    self.sortParameter = sortParameter
    self.typeParameter = typeParameter
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
      print("CommentsFetcher REF \(urlRequest.url as Any)")
      urlRequest.cachePolicy = .reloadRevalidatingCacheData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200..<300)
    .responseDecodable(of: CommentModel.self) { response in
      switch response.result {
      case let .success(result):
        let newComments = result.comments

        let filteredNewComments = newComments.filter { newComment in
          !self.comments.contains { $0.comment.id == newComment.comment.id }
        }

        DispatchQueue.main.async {
          self.comments.insert(contentsOf: filteredNewComments, at: 0)
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
      print("CommentsFetcher LOAD \(urlRequest.url as Any)")
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
}

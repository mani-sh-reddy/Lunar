//
//  CommentsFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Defaults
import Foundation
import SwiftUI

class CommentsFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.commentSort) var commentSort
  @Default(.commentType) var commentType
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  @Published var comments = [CommentObject]()
  @Published var isLoading = false

  private var currentPage = 1
  private var postID: Int
  private var limitParameter: Int = 50
  private let maxDepth: Int = 50

  private var parameters: EndpointParameters {
    EndpointParameters(
      endpointPath: "/api/v3/comment/list",
      sortParameter: commentSort,
      typeParameter: commentType,
      currentPage: currentPage,
      limitParameter: limitParameter,
      postID: postID,
      maxDepth: maxDepth,
      jwt: JWT().getJWTForActiveAccount()
    )
  }

  init(postID: Int) {
    self.postID = postID
    loadContent()
  }

  func loadContent(isRefreshing: Bool = false) {
    if isRefreshing {
      comments.removeAll()
      currentPage = 1
    }

    guard !isLoading else { return }

    isLoading = true

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
    }

    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CommentModel.self) { response in

      PulseWriter().write(response, self.parameters, .get)

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

        if !isRefreshing {
          self.currentPage += 1
        }

      case let .failure(error):
        print("CommentsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
      }
    }
  }

  func updateCommentCollapseState(_ comment: CommentObject, isCollapsed: Bool) {
    if let index = comments.firstIndex(where: { $0.comment.id == comment.comment.id }) {
      comments[index].isCollapsed = isCollapsed
    }
  }
}

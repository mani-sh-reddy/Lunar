//
//  CommentsFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Combine
import Foundation
import Pulse
import SwiftUI

@MainActor class CommentsFetcher: ObservableObject {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("commentSort") var commentSort = Settings.commentSort
  @AppStorage("commentType") var commentType = Settings.commentType
  @AppStorage("networkInspectorEnabled") var networkInspectorEnabled = Settings.networkInspectorEnabled
  @Published var comments = [CommentObject]()
  @Published var isLoading = false

  private var currentPage = 1
  private var postID: Int
  private var limitParameter: Int = 50
  private let maxDepth: Int = 50

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/comment/list",
      sortParameter: commentSort,
      typeParameter: commentType,
      currentPage: currentPage,
      limitParameter: limitParameter,
      postID: postID,
      maxDepth: maxDepth,
      jwt: getJWTFromKeychain()
    ).buildURL()
  }
  
  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/comment/list",
      sortParameter: commentSort,
      typeParameter: commentType,
      currentPage: currentPage,
      limitParameter: limitParameter,
      postID: postID,
      maxDepth: maxDepth
    ).buildURL()
  }
  
  let pulse = Pulse.LoggerStore.shared

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
    
    AF.request(endpoint) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
    }
    
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: CommentModel.self) { response in
      
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

  func updateCommentCollapseState(_ comment: CommentObject, isCollapsed: Bool) {
    if let index = comments.firstIndex(where: { $0.comment.id == comment.comment.id }) {
      comments[index].isCollapsed = isCollapsed
    }
  }

  func updateCommentShrinkState(_ comment: CommentObject, isShrunk: Bool) {
    if let index = comments.firstIndex(where: { $0.comment.id == comment.comment.id }) {
      comments[index].isShrunk = isShrunk
    }
  }
}

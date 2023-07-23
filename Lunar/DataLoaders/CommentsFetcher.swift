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
            endpointPath: "/api/v3/post/list",
            sortParameter: sortParameter,
            typeParameter: typeParameter,
            currentPage: currentPage,
            limitParameter: limitParameter,
            postID: postID
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
            print(urlRequest.url as Any)
            urlRequest.cachePolicy = .reloadRevalidatingCacheData
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: CommentModel.self) { response in
            switch response.result {
            case let .success(result):
                print("current comments @published object: \(self.comments.count)")
                let newComments = result.comments
                print("newPosts: \(newComments.count)")

                let filteredNewComments = newComments.filter { newComment in
                    !self.comments.contains { $0.comment.id == newComment.comment.id }
                }

                print("filteredNewPosts: \(filteredNewComments.count)")
                self.comments.insert(contentsOf: filteredNewComments, at: 0)
                print("new posts @published object: \(self.comments.count)")
                self.isLoading = false

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
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
            print(urlRequest.url as Any)
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: CommentModel.self) { response in
            switch response.result {
            case let .success(result):

                let newComments = result.comments

                let filteredNewComments = newComments.filter { newComments in
                    !self.comments.contains { $0.comment.id == newComments.comment.id }
                }

                if !filteredNewComments.isEmpty {
                    DispatchQueue.global().async {
                        let sortedFilteredComments = filteredNewComments.sorted { $0.comment.path < $1.comment.path }
                        for newComment in sortedFilteredComments {
                            InsertSorter.sortComments(newComment, into: &self.comments)
                        }

                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    }
                } else {
                    self.isLoading = false
                }

                self.currentPage += 1

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

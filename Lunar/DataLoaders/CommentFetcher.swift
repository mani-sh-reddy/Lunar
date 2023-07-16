//
//  CommentFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher

@MainActor class CommentFetcher: ObservableObject {
    @Published var comments = [CommentElement]()
    @Published var isLoading = false

    private var currentPage = 1
    private var postID: Int = 0

    init(postID: Int) {
        self.postID = postID
        loadMoreContent()
    }

    func refreshContent() async {
        do {
            try await Task.sleep(nanoseconds: 1_000_000_000)
        } catch {
            //
        }

        guard !isLoading else { return }

        isLoading = true

        currentPage = 1

        let url = URL(string: buildEndpoint())!
        let cacher = ResponseCacher(behavior: .cache)

        AF.request(url) { urlRequest in
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

                // Filter out existing posts from new posts
                let filteredNewComments = newComments.filter { newComment in
                    !self.comments.contains { $0.comment.id == newComment.comment.id }
                }

                print("filteredNewPosts: \(filteredNewComments.count)")

                // Prepend filtered new posts to the front of the list
                self.comments.insert(contentsOf: filteredNewComments, at: 0)

                print("new posts @published object: \(self.comments.count)")

                self.isLoading = false

//                let cachableImageURLs = result.thumbnailURLs.compactMap { URL(string: $0) }
//                    + result.avatarURLs.compactMap { URL(string: $0) }
//                let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
//                prefetcher.start()

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
        let thresholdIndex = comments.index(comments.endIndex, offsetBy: -3)
        if comments.firstIndex(where: { $0.comment.id == comment.comment.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        guard !isLoading else { return }

        isLoading = true

        let url = URL(string: buildEndpoint())!
        let cacher = ResponseCacher(behavior: .cache)

        print("ENDPOINT: \(url)")

        AF.request(url) { urlRequest in
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: CommentModel.self) { response in
            switch response.result {
            case let .success(result):

                let newComments = result.comments

                // Filter out existing posts from new posts
                let filteredNewComments = newComments.filter { newComments in
                    !self.comments.contains { $0.comment.id == newComments.comment.id }
                }

                self.comments += filteredNewComments

                self.isLoading = false
                self.currentPage += 1

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }

    private func buildEndpoint() -> String {
        /// let urlString = "https://lemmy.world/api/v3/comment/list?type_=All&sort=Top&limit=50&post_id=\(postId)&max_depth=\(commentMaxDepth)"

        // TODO: -
        let sortParameter = "Top"
        let commentMaxDepth = "1"

        let baseURL = "https://lemmy.world/api/v3/comment/list"
        let sortQuery = "sort=\(sortParameter)"
        let limitQuery = "limit=20"
        let pageQuery = "page=\(currentPage)"
        let maxDepthQuery = "max_depth=\(commentMaxDepth)"
        let postIDQuery = "post_id=\(postID)"

        let endpoint = "\(baseURL)?\(sortQuery)&\(limitQuery)&\(pageQuery)&\(maxDepthQuery)&\(postIDQuery)"
        return endpoint
    }
}

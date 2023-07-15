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

class CommentFetcher: ObservableObject {
    @Published var comments = [CommentElement]()
    @Published var isLoading = false

    private var currentPage = 1
    private var postID: Int = 0

    init(postID: Int) {
        self.postID = postID
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem comment: CommentElement?) {
        guard let comment = comment else {
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

        AF.request(url) { urlRequest in
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: CommentModel.self) { response in
            switch response.result {
            case let .success(result):
                self.comments += result.comments
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
        print("ENDPOINT: \(endpoint)")
        return endpoint
    }
}

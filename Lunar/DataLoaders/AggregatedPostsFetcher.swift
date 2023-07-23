//
//  AggregatedPostsFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher
import SwiftUI

@MainActor class AggregatedPostsFetcher: ObservableObject {
    @Published var posts = [PostElement]()
    @Published var isLoading = false

    private var currentPage = 1
    private var sortParameter: String
    private var typeParameter: String
    private var endpoint: URLComponents {
        URLBuilder(
            endpointPath: "/api/v3/post/list",
            sortParameter: sortParameter,
            typeParameter: typeParameter,
            currentPage: currentPage
        ).buildURL()
    }

    init(
        sortParameter: String,
        typeParameter: String
    ) {
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
        .responseDecodable(of: PostsModel.self) { response in
            switch response.result {
            case let .success(result):
                print("current posts @published object: \(self.posts.count)")

                let newPosts = result.posts

                print("newPosts: \(newPosts.count)")

                // Filter out existing posts from new posts
                let filteredNewPosts = newPosts.filter { newPost in
                    !self.posts.contains { $0.post.id == newPost.post.id }
                }

                print("filteredNewPosts: \(filteredNewPosts.count)")

                // Prepend filtered new posts to the front of the list
                self.posts.insert(contentsOf: filteredNewPosts, at: 0)

                print("new posts @published object: \(self.posts.count)")

                self.isLoading = false

                let cachableImageURLs = result.thumbnailURLs.compactMap { URL(string: $0) }
                    + result.avatarURLs.compactMap { URL(string: $0) }
                let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
                prefetcher.start()

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }

    func loadMoreContentIfNeeded(currentItem item: PostElement?) {
        guard let item else {
            loadMoreContent()
            return
        }
        /// preload early
        var thresholdIndex = posts.index(posts.endIndex, offsetBy: -5)
        if posts.firstIndex(where: { $0.post.id == item.post.id }) == thresholdIndex {
            loadMoreContent()
        }
        /// preload when reached the bottom
        thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)
        if posts.firstIndex(where: { $0.post.id == item.post.id }) == thresholdIndex {
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
        .responseDecodable(of: PostsModel.self) { response in
            switch response.result {
            case let .success(result):
                let newPosts = result.posts

                let filteredNewPosts = newPosts.filter { newPost in
                    !self.posts.contains { $0.post.id == newPost.post.id }
                }

                self.posts += filteredNewPosts
                self.isLoading = false
                self.currentPage += 1

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }
}

//
//  CommunityFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

@MainActor class CommunityFetcher: ObservableObject {
    @Published var communities = [CommunityElement]()
    @Published var isLoading = false

    private var currentPage = 1
    private var sortParameter: String
    private var limitParameter: String
//    private var postID: Int = 0

    init(sortParameter: String, limitParameter: String) {
        self.sortParameter = sortParameter
        self.limitParameter = limitParameter
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
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: CommunityModel.self) { response in
            switch response.result {
            case let .success(result):
                print("current communities @published object: \(self.communities.count)")

                let newCommunities = result.communities

                print("newCommunities: \(newCommunities.count)")

                // Filter out existing posts from new posts
                let filteredNewCommunities = newCommunities.filter { newCommunity in
                    !self.communities.contains { $0.community.id == newCommunity.community.id }
                }

                print("filteredNewCommunities: \(filteredNewCommunities.count)")

                // Prepend filtered new posts to the front of the list
                self.communities.insert(contentsOf: filteredNewCommunities, at: 0)

                print("new communities @published object: \(self.communities.count)")

                self.isLoading = false

                let cachableImageURLs = result.iconURLs.compactMap { URL(string: $0) }
                let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
                prefetcher.start()

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }

    func loadMoreContentIfNeeded(currentItem community: CommunityElement?) {
        guard let community else {
            loadMoreContent()
            return
        }
        let thresholdIndex = communities.index(communities.endIndex, offsetBy: -20)
        if communities.firstIndex(where: { $0.community.id == community.community.id }) == thresholdIndex {
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
        .responseDecodable(of: CommunityModel.self) { response in
            switch response.result {
            case let .success(result):

                let newCommunities = result.communities

                // Filter out existing posts from new posts
                let filteredNewCommunities = newCommunities.filter { newCommunities in
                    !self.communities.contains { $0.community.id == newCommunities.community.id }
                }

                self.communities += filteredNewCommunities

                self.isLoading = false
                self.currentPage += 1

            case let .failure(error):
                print("ERROR: \(error): \(error.errorDescription ?? "")")
            }
        }
    }

    private func buildEndpoint() -> String {
        /// https://lemmy.world/api/v3/community/list?type_=All&sort=New&page=1&limit=5

        // TODO: -
        let typeParameter = "All"

        let baseURL = "https://lemmy.world/api/v3/community/list"
        let sortQuery = "sort=\(sortParameter)"
        let typeQuery = "type=\(typeParameter)"
        let limitQuery = "limit=\(limitParameter)"
        let pageQuery = "page=\(currentPage)"

        let endpoint = "\(baseURL)?\(sortQuery)&\(typeQuery)&\(limitQuery)&\(pageQuery)"
        return endpoint
    }
}

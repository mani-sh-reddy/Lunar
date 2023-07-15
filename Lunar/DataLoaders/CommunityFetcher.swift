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

class CommunityFetcher: ObservableObject {
    @Published var communities = [CommunityElement]()
    @Published var isLoading = false

    private var currentPage = 1

    /// 0 = initial state
    /// 1 = load first 5
    /// 2 = load infinitely
    private var loadInfinitely: Bool
    private var shouldLoad: Bool = true
    private var sortParameter: String
    private var limitParameter: String

    init(loadInfinitely: Bool, sortParameter: String, limitParameter: String) {
        self.loadInfinitely = loadInfinitely
        self.sortParameter = sortParameter
        self.limitParameter = limitParameter
        loadMoreContent()
    }
    

    func refreshContent() {
        communities = []
        currentPage = 1
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem community: CommunityElement?, loadInfinitely: Bool) {
        self.loadInfinitely = loadInfinitely
        guard let community = community else {
            loadMoreContent()
            return
        }

        let thresholdIndex = communities.index(communities.endIndex, offsetBy: -3)
        if communities.firstIndex(where: { $0.community.id == community.community.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        if !loadInfinitely{
            guard !isLoading else { return }
            guard shouldLoad else { return }
        }
        
        //FIXME: - Fix infinite loading bug

        isLoading = true

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
                self.communities += result.communities
                self.isLoading = false
                self.currentPage += 1

                if self.loadInfinitely {
                    self.shouldLoad = true
                } else {
                    self.shouldLoad = false
                }

                let cachableImageURLs = result.iconURLs.compactMap { URL(string: $0) }
                let prefetcher = ImagePrefetcher(urls: cachableImageURLs) { _, _, _ in }
                prefetcher.start()

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
        print("ENDPOINT: \(endpoint)")
        return endpoint
    }
}

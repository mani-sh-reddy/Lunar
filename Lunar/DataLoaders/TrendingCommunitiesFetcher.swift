//
//  TrendingCommunitiesFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//

import Alamofire
import Foundation
import Kingfisher
import SwiftUI

@MainActor class TrendingCommunitiesFetcher: ObservableObject {
    @Published var communities = [CommunityElement]()
    @Published var isLoading = false

    private var currentPage = 1
    private var sortParameter: String
    private var limitParameter: String

    init(sortParameter: String, limitParameter: String) {
        self.sortParameter = sortParameter
        self.limitParameter = limitParameter
        loadContent()
    }

//    func refreshContent() async {
//        do {
//            try await Task.sleep(nanoseconds: 2_000_000_000)
//            communities = []
//            currentPage = 1
//            loadContent()
//
//        } catch {
//            // TODO: do some error handling
//        }
//    }

    private func loadContent() {
        guard !isLoading else { return }

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
                self.communities = result.communities
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
        print("ENDPOINT: \(endpoint)")
        return endpoint
    }
}

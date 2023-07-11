//
//  PostsListFetcher.swift
//  Lunar
//
//  Created by Mani on 09/07/2023.
//
import Alamofire
import Combine
import Foundation

class PostsListFetcher: ObservableObject {
    @Published var items = [PostElement]()
    @Published var isLoadingPage = false

    private var currentPage = 1
    private var canLoadMorePages = true

    private var communityID: Int = 0
    private var prop: [String: String] = [:]

    init(communityID: Int, prop: [String: String]) {
        self.communityID = communityID
        self.prop = prop
        loadMoreContent()
    }

    func loadMoreContentIfNeeded(currentItem item: PostElement?) {
        guard let item = item else {
            loadMoreContent()
            return
        }
        let thresholdIndex = items.index(items.endIndex, offsetBy: -3)
        if items.firstIndex(where: { $0.post.id == item.post.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    private func loadMoreContent() {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }

        isLoadingPage = true

        let url = URL(string: buildEndpoint())!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PostsModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { _ in
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map { response in
                self.items + response.posts
            }
            .catch { _ in Just(self.items) }
            .assign(to: &$items)
    }

    private func buildEndpoint() -> String {
        let sortParameter = prop["sort"] ?? "Active"
        let typeParameter = prop["type"] ?? "All"

        let baseURL = "https://lemmy.world/api/v3/post/list"
        let sortQuery = "sort=\(sortParameter)"
        let limitQuery = "limit=5"
        let pageQuery = "page=\(currentPage)"

        var prefixQuery = ""

        if communityID == 0 {
            prefixQuery = "type_=\(typeParameter)"
        } else {
            prefixQuery = "community_id=\(communityID)"
        }

        let endpoint = "\(baseURL)?\(sortQuery)&\(limitQuery)&\(pageQuery)&\(prefixQuery)"
        print("ENDPOINT: \(endpoint)")
        return endpoint
    }
}

//
//  LoadTrendingCommunities.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import Foundation
import Kingfisher


class AllPostsListLoader: ObservableObject {
    @Published var posts: [PostElement] = []
    @Published var thumbnailURLsStrings: [String] = []
    
    init() {
        let url = URL(string: "https://lemmy.world/api/v3/post/list?type_=All&sort=Active&limit=50")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PostsModel.self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decodedResponse.posts
                        self.thumbnailURLsStrings = decodedResponse.thumbnailURLs
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

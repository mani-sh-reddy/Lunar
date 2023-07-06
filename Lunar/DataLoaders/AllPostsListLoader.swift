//
//  LoadTrendingCommunities.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import Foundation


class AllPostsListLoader: ObservableObject {
    @Published var posts: [PostElement] = []
    
    init() {
        let url = URL(string: "https://lemmy.world/api/v3/post/list?type_=All&sort=Hot&limit=50")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(PostsModel.self, from: data) {
                    DispatchQueue.main.async {
                        self.posts = decodedResponse.posts
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

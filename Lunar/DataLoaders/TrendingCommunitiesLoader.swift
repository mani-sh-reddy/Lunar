//
//  LoadTrendingCommunities.swift
//  Lunar
//
//  Created by Mani on 06/07/2023.
//

import Foundation


class TrendingCommunitiesLoader: ObservableObject {
    @Published var communities: [CommunitiesElement] = []
    @Published var iconURLsStrings: [String] = []
    
    init() {
        let url = URL(string: "https://lemmy.world/api/v3/community/list?sort=Hot&limit=5")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(CommunityModel.self, from: data) {
                    DispatchQueue.main.async {
                        self.communities = decodedResponse.communities
                        self.iconURLsStrings = decodedResponse.iconURLs
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
}

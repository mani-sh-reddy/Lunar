//
//  TrendingCommunitiesListView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct TrendingCommunitiesListView: View {
    @ObservedObject var trendingCommunities = TrendingCommunitiesLoader()
    
    var body: some View {
        ForEach(trendingCommunities.communities, id: \.community.id) { communities in
            NavigationLink {
                CommunityInfoView(community: communities.community)
            } label: {
                CommunityRowView(community: communities)
            }
            .onAppear(perform: {
                let iconURLs = trendingCommunities.iconURLsStrings.compactMap { URL(string: $0) }
                let prefetcher = ImagePrefetcher(urls: iconURLs) {
                    _, _, _ in
                }
                prefetcher.start()
                
            })
        }
    }
}

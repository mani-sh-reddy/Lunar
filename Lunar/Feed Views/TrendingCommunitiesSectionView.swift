//
//  TrendingCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct TrendingCommunitiesSectionView: View {
    @StateObject var trendingCommunitiesFetcher: TrendingCommunitiesFetcher

    var body: some View {
        ForEach(trendingCommunitiesFetcher.communities, id: \.community.id) { community in

            NavigationLink(destination: CommunitySpecificPostsListView(
                communitySpecificPostsFetcher: CommunitySpecificPostsFetcher(
                    communityID: community.community.id,
                    sortParameter: "Hot",
                    typeParameter: "Local"
                ),
                communityID: community.community.id,
                title: community.community.title
            )) {
                CommunityRowView(community: community)
            }
        }
        if trendingCommunitiesFetcher.isLoading {
            ProgressView()
        }
    }
}

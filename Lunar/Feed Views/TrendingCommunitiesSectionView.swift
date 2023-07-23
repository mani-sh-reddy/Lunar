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

            let communitySpecificPostsFetcher = CommunitySpecificPostsFetcher(
                communityID: community.community.id,
                sortParameter: "Hot",
                typeParameter: "Local"
            )

            let destination = CommunitySpecificPostsListView(
                communitySpecificPostsFetcher: communitySpecificPostsFetcher,
                communityID: community.community.id,
                title: community.community.title
            )

            NavigationLink(destination: destination) {
                CommunityRowView(community: community)
            }
        }
        if trendingCommunitiesFetcher.isLoading {
            ProgressView()
        }
        MoreCommunitiesButtonView()
    }
}

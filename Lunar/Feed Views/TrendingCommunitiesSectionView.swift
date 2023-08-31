//
//  TrendingCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct TrendingCommunitiesSectionView: View {
  @StateObject var trendingCommunitiesFetcher: TrendingCommunitiesFetcher
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance

  var body: some View {
    ForEach(trendingCommunitiesFetcher.communities, id: \.community.id) { community in

      // TODO: -
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            communityID: community.community.id
          ), title: community.community.name,
          community: community
        )
      } label: {
        CommunityRowView(community: community)
      }

      //      NavigationLink(
      //        destination: CommunitySpecificPostsListView(
      //          communitySpecificPostsFetcher: CommunitySpecificPostsFetcher(
      //            communityID: community.community.id,
      //            sortParameter: "Hot",
      //            typeParameter: "Local"
      //          ),
      //          communityID: community.community.id,
      //          title: community.community.title
      //        )
      //      ) {
      //        CommunityRowView(community: community)
      //      }
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        await trendingCommunitiesFetcher.refreshContent()
      }
    }
    if trendingCommunitiesFetcher.isLoading {
      ProgressView()
    }
  }
}

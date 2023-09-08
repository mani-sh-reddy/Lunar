//
//  TrendingCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct TrendingCommunitiesSectionView: View {
  @StateObject var communitiesFetcher: CommunitiesFetcher
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance

  var body: some View {
    ForEach(communitiesFetcher.communities, id: \.community.id) { community in

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
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        communitiesFetcher.loadContent(isRefreshing: true)
      }
    }
    if communitiesFetcher.isLoading {
      ProgressView()
    }
  }
}

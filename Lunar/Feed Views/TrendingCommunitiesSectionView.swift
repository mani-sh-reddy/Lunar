//
//  TrendingCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Defaults
import RealmSwift
import SwiftUI

struct TrendingCommunitiesSectionView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @Default(.selectedInstance) var selectedInstance

  @StateObject var communitiesFetcher: LegacyCommunitiesFetcher

  var body: some View {
    ForEach(communitiesFetcher.communities, id: \.community.id) { community in
      NavigationLink {
        PostsView(
          filteredPosts: realmPosts.filter { post in
            post.sort == "Active" && post.type == "All"
              && post.communityID == community.community.id && post.filterKey == "communitySpecific"
          },
          sort: "Active",
          type: "All",
          user: 0,
          communityID: community.community.id,
          personID: 0,
          filterKey: "communitySpecific",
          heading: community.community.title,
          communityName: community.community.name,
          communityActorID: community.community.actorID,
          communityDescription: community.community.description,
          communityIcon: community.community.icon
        )
      } label: {
        LegacyCommunityRowView(community: community)
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

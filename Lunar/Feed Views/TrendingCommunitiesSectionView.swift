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
  @ObservedResults(RealmPage.self) var realmPage

  @Default(.selectedInstance) var selectedInstance

  @StateObject var communitiesFetcher: LegacyCommunitiesFetcher

  var body: some View {
    ForEach(communitiesFetcher.communities.prefix(5), id: \.community.id) { community in
      NavigationLink {
        PostsView(
          realmPage: realmPage.sorted(byKeyPath: "timestamp", ascending: false).first(where: {
            $0.sort == "Active"
              && $0.type == "All"
              && $0.communityID == community.community.id
              && $0.filterKey == "communitySpecific"
          }) ?? RealmPage(),
          filteredPosts: realmPosts.filter { post in
            post.sort == "Active"
              && post.type == "All"
              && post.communityID == community.community.id
              && post.filterKey == "communitySpecific"
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
        CommunityItem(community: convertToRealmCommunity(community: community))
          .environmentObject(communitiesFetcher)
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

  func convertToRealmCommunity(community: CommunityObject) -> RealmCommunity {
    RealmCommunity(
      id: community.community.id,
      name: community.community.name,
      title: community.community.title,
      actorID: community.community.actorID,
      instanceID: community.community.instanceID,
      descriptionText: community.community.description,
      icon: community.community.icon,
      banner: community.community.banner,
      postingRestrictedToMods: community.community.postingRestrictedToMods,
      published: community.community.published,
      subscribers: community.counts.subscribers,
      posts: community.counts.posts,
      comments: community.counts.comments,
      subscribed: community.subscribed
    )
  }
}

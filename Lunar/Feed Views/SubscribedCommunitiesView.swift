//
//  SubscribedCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Defaults
import SwiftUI

struct SubscribedCommunitiesSectionView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.selectedInstance) var selectedInstance
  @Default(.subscribedCommunityIDs) var subscribedCommunityIDs

  @StateObject var communitiesFetcher: CommunitiesFetcher

  var body: some View {
    SubscribedFeedQuicklink()

    ForEach(communitiesFetcher.communities, id: \.community.id) { community in
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            communityID: community.community.id
          ),
          title: community.community.name,
          community: community
        )
      } label: {
        CommunityRowView(community: community)
      }
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        communitiesFetcher.loadContent()
      }
    }
    .onChange(of: activeAccount) { _ in
      Task {
        try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        communitiesFetcher.loadContent(isRefreshing: true)
      }
    }
    .onChange(of: subscribedCommunityIDs) { _ in
      Task {
        try await Task.sleep(nanoseconds: UInt64(2 * Double(NSEC_PER_SEC)))
        communitiesFetcher.loadContent(isRefreshing: true)
      }
    }

    if communitiesFetcher.isLoading {
      ProgressView()
    }
    if debugModeEnabled {
      Text("subscribedCommunityIDs App Storage Array:")
      Text(String(describing: subscribedCommunityIDs))
      Button {
        subscribedCommunityIDs.removeAll()
      } label: {
        Text("Clear subscribedCommunityIDs Array")
      }
    }
  }
}

//
//  SubscribedCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct SubscribedCommunitiesSectionView: View {
  @StateObject var communitiesFetcher: CommunitiesFetcher
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("subscribedCommunityIDs") var subscribedCommunityIDs = Settings.subscribedCommunityIDs
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

  var body: some View {
    SubscribedFeedButton()

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
    .onChange(of: selectedActorID) { _ in
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

struct SubscribedFeedButton: View {
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

  var subscribedPostsButton: CommunityButton {
    CommunityButton(
      title: "Subscribed Feed",
      type: "Subscribed",
      sort: "Active",
      icon: "pin.circle.fill",
      iconColor: .purple
    )
  }

  var body: some View {
    if selectedActorID.isEmpty {
      HStack {
        Image(systemName: "lock.circle.fill")
          .resizable()
          .frame(width: 30, height: 30)
          .symbolRenderingMode(.monochrome)
          .foregroundColor(.blue)
        Text("Login to view subscriptions")
          .foregroundColor(.blue)
          .padding(.horizontal, 10)
      }
    } else {
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            sortParameter: subscribedPostsButton.sort,
            typeParameter: subscribedPostsButton.type
          ), title: subscribedPostsButton.title
        )
      } label: {
        GeneralCommunityButtonView(button: subscribedPostsButton)
      }
    }
  }
}

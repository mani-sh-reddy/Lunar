//
//  SubscribedCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct SubscribedCommunitiesSectionView: View {
  @StateObject var communitiesFetcher = CommunitiesFetcher(
    limitParameter: 50, sortParameter: "Active", typeParameter: "Subscribed")
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("subscribedCommunityIDs") var subscribedCommunityIDs = Settings.subscribedCommunityIDs
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

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
    ForEach(communitiesFetcher.communities, id: \.community.id) { community in
      /// get all the community IDs fetched from server,
      /// append it to already existing AppStorage array and remove duplicates
      //        let _ = subscribedCommunityIDs.append(community.community.id)
      let _ = print("TESt")
      let _ = print(subscribedCommunityIDs)
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

    //      .task {
    //        let subscribedCommunityIDs = Set(subscribedCommunityIDs.map { $0 })
    //        let fetchedCommunityIDs = Set(communitiesFetcher.communities.map { $0.community.id })
    //        if subscribedCommunityIDs != fetchedCommunityIDs {
    //          let newSubscribedCommunities = communitiesFetcher.communities.filter { fetchedCommunityIDs.contains($0.community.id) }
    //          subscribedCommunityIDs = newSubscribedCommunities.map{$0.community.id }
    //          let newCommunityIDs = fetchedCommunityIDs.subtracting(subscribedCommunityIDs)
    //          for communityID in newCommunityIDs {
    //            print(communityID)
    //          }
    //        }
    //      }

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
    EmptyView()
      .onChange(of: instanceHostURL) { _ in
        Task {
          await communitiesFetcher.refreshContent()
        }
      }
  }
}

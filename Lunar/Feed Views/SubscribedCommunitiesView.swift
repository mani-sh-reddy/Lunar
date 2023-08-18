//
//  SubscribedCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct SubscribedCommunitiesSectionView: View {
  @StateObject var communitiesFetcher: CommunitiesFetcher
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  
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
      ForEach(communitiesFetcher.communities, id: \.community.id) { community in
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
    }
    if communitiesFetcher.isLoading {
      ProgressView()
    }
    EmptyView()
      .onChange(of: instanceHostURL) { _ in
        Task {
          await communitiesFetcher.refreshContent()
        }
      }
    
  }
}

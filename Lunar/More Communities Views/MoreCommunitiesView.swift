//
//  MoreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import SwiftUI

struct MoreCommunitiesView: View {
  @StateObject var communitiesFetcher: CommunitiesFetcher
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

  var title: String

  var body: some View {
    List {
      Section {
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
          .task {
            communitiesFetcher.loadMoreContentIfNeeded(currentItem: community)
          }
        }
      } header: {
        Text("Sorted by New")
      }

      .accentColor(Color.primary)
      if communitiesFetcher.isLoading {
        ProgressView()
      }
    }.listStyle(.insetGrouped)
      .navigationTitle(title)
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "sparkles") }
      }
      .refreshable {
        await communitiesFetcher.refreshContent()
      }
  }
}

struct MoreCommunitiesView_Previews: PreviewProvider {
  static var previews: some View {
    let communitiesFetcher = CommunitiesFetcher(
      limitParameter: 50,
      sortParameter: "Active",
      typeParameter: "All"
    )
    MoreCommunitiesView(
      communitiesFetcher: communitiesFetcher,
      title: "Explore Communities"
    )
  }
}

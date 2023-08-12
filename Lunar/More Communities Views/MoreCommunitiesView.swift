//
//  MoreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import SwiftUI

struct MoreCommunitiesView: View {
  @StateObject var communitiesFetcher: CommunitiesFetcher
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL

  var title: String

  var body: some View {
    List {
      Section {
        ForEach(communitiesFetcher.communities, id: \.community.id) { community in
          
          // TODO: -
          NavigationLink {
            Text(String(describing: community.community))
          } label: {
            CommunityRowView(community: community)
          }

//          NavigationLink(
//            destination: CommunitySpecificPostsListView(
//              communitySpecificPostsFetcher: CommunitySpecificPostsFetcher(
//                communityID: community.community.id,
//                sortParameter: "Active",
//                typeParameter: "All"
//              ),
//              communityID: community.community.id,
//              title: community.community.title
//            )
//          ) {
//            MoreCommunitiesRowView(community: community)
//          }
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
      sortParameter: "Active",
      typeParameter: "All",
      limitParameter: 50
    )
    MoreCommunitiesView(
      communitiesFetcher: communitiesFetcher,
      title: "Explore Communities"
    )
  }
}

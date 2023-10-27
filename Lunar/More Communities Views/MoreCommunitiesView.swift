//
//  MoreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import RealmSwift
import SwiftUI

struct MoreCommunitiesView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @StateObject var communitiesFetcher: CommunitiesFetcher

  var title: String

  var body: some View {
    List {
      Section {
        ForEach(communitiesFetcher.communities, id: \.community.id) { community in
//          let _ = print(URLParser.extractDomain(from: community.community.actorID))
          NavigationLink {
            PostsView(
              filteredPosts: realmPosts.filter { post in
                post.sort == "Active" &&
                  post.type == "All" &&
                  post.communityID == community.community.id &&
                  post.filterKey == "communitySpecific"
              },
              sort: "Active",
              type: "All",
              user: 0,
              communityID: community.community.id,
              personID: 0,
              filterKey: "communitySpecific",
              heading: community.community.title
            )
//            PostsView(
//              sort: "Active",
//              type: "All",
//              user: 0,
//              communityID: community.community.id,
//              personID: 0,
//              heading: community.community.title
//            )
//            PostsView(
//              postsFetcher: PostsFetcher(
//                communityID: community.community.id,
//                instance: URLParser.extractDomain(from: community.community.actorID)
//              ),
//              title: community.community.name,
//              community: community
//            )
          } label: {
            CommunityRowView(community: community)
          }
          .onAppear {
            communitiesFetcher.loadMoreContentIfNeeded(currentItem: community)
          }
        }
      } header: {
        Text("Sorted by New")
      }
      .accentColor(Color.primary)
//      if communitiesFetcher.isLoading {
//        ProgressView()
//      }
    }
    .refreshable {
      communitiesFetcher.loadContent(isRefreshing: true)
    }
    .listStyle(.insetGrouped)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) { Image(systemSymbol: .sparkles) }
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

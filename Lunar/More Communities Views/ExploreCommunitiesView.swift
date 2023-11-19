//
//  ExploreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import RealmSwift
import SwiftUI

struct ExploreCommunitiesView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @StateObject var communitiesFetcher: LegacyCommunitiesFetcher

  @State private var sortType: SortType = .new

  var title: String

  var body: some View {
    List {
      Section {
        ForEach(communitiesFetcher.communities, id: \.community.id) { community in
          NavigationLink {
            PostsView(
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
            LegacyCommunityRowView(
              community: community,
              communitiesFetcher: communitiesFetcher
            )
          }
        }
      } header: {
        Text(sortType.rawValue)
      }
      .accentColor(Color.primary)
      ZStack {
        Rectangle()
          .foregroundStyle(.gray.opacity(0.1))
          .onAppear { loadMoreCommunitiesOnAppear() }
        ProgressView()
          .id(UUID())
      }
      if communitiesFetcher.isLoading {
        ProgressView()
      }
    }
    .refreshable {
      try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
      communitiesFetcher.loadContent(isRefreshing: true)
    }
    .listStyle(.insetGrouped)
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        SortPicker(sortType: $sortType)
      }
    }
    .onChange(of: sortType) { _ in
      withAnimation {
        communitiesFetcher.sortParameter = sortType.rawValue
        communitiesFetcher.loadContent(isRefreshing: true)
      }
    }
  }

  func loadMoreCommunitiesOnAppear() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      communitiesFetcher.loadContent()
    }
  }
}

struct MoreCommunitiesView_Previews: PreviewProvider {
  static var previews: some View {
    let communitiesFetcher = LegacyCommunitiesFetcher(
      limitParameter: 50,
      sortParameter: "Active",
      typeParameter: "All"
    )
    ExploreCommunitiesView(
      communitiesFetcher: communitiesFetcher,
      title: "Explore Communities"
    )
  }
}

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
  @ObservedResults(RealmPage.self) var realmPage

  @StateObject var communitiesFetcher: LegacyCommunitiesFetcher

  @State private var sortType: SortType = .new

  var title: String

  var body: some View {
    List {
      Section {
        ForEach(communitiesFetcher.communities, id: \.community.id) { community in
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

#Preview {
  ExploreCommunitiesView(
    communitiesFetcher: LegacyCommunitiesFetcher(
      limitParameter: 50,
      sortParameter: "Active",
      typeParameter: "All"
    ),
    title: "Explore Communities"
  )
}

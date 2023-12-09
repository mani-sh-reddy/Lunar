//
//  SubscribedCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Defaults
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct SubscribedCommunitiesSectionView: View {
  @Default(.activeAccount) var activeAccount

  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts
  @ObservedResults(RealmCommunity.self, where: ({ $0.subscribed != .notSubscribed })) var realmCommunities

  @State var fetchCounter: Int = 0

  let realm = try! Realm()

  var body: some View {
    if !activeAccount.actorID.isEmpty {
      DisclosureGroup {
        ForEach(realmCommunities, id: \.id) { community in
          NavigationLink {
            PostsView(
              filteredPosts: realmPosts.filter { post in
                post.sort == "Active"
                  && post.type == "All"
                  && post.communityID == community.id
                  && post.filterKey == "communitySpecific"
              },
              sort: "Active",
              type: "All",
              user: 0,
              communityID: community.id,
              personID: 0,
              filterKey: "communitySpecific",
              heading: community.title ?? community.name,
              communityName: community.name,
              communityActorID: community.actorID,
              communityDescription: community.descriptionText,
              communityIcon: community.icon
            )
          } label: {
            CommunityItem(community: community)
              .padding(.leading, -20)
          }
        }
      } label: {
        userSubscriptionsDisclosureGroupLabel
      }
      .disabled(realmCommunities.count == 0)
    }

    SubscribedFeedQuicklink()
      .onAppear {
        if fetchCounter < 1 {
          print("=====Refetching subscriptions=====")
          fetchSubscribedCommunities()
        }
      }
      .onChange(of: activeAccount.actorID) { _ in
        try! realm.write {
          let communities = realm.objects(RealmCommunity.self)
          realm.delete(communities)
        }
        fetchSubscribedCommunities()
      }
      .disabled(realmCommunities.count == 0)
  }

  var userSubscriptionsDisclosureGroupLabel: some View {
    HStack {
      Image(systemSymbol: .person2CircleFill)
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundColor(.orange)

      Text("Subscribed Communities")
        .padding(.horizontal, 10)
        .foregroundColor(.primary)

      Spacer()

      Text(String(realmCommunities.count))
        .bold()
        .font(.caption)
        .foregroundStyle(.secondary)
    }
  }

  func fetchSubscribedCommunities() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      CommunitiesFetcher(
        limitParameter: 50,
        sortParameter: "Active",
        typeParameter: "Subscribed"
      ).loadContent()
      fetchCounter += 1
    }
  }
}

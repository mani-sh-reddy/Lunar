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

// communitiesFetcher: CommunitiesFetcher(
//  limitParameter: 50, sortParameter: "Active", typeParameter: "Subscribed"
// ))

struct SubscribedCommunitiesSectionView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts
  @ObservedResults(RealmCommunity.self, where: ({ $0.subscribed != .notSubscribed })) var realmCommunities

  @State var fetchCounter: Int = 0

  @Default(.activeAccount) var activeAccount
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.selectedInstance) var selectedInstance
  @Default(.subscribedCommunityIDs) var subscribedCommunityIDs

  let realm = try! Realm()

  var body: some View {
    if !activeAccount.actorID.isEmpty {
      DisclosureGroup {
        ForEach(realmCommunities, id: \.id) { community in
          NavigationLink {
            PostsView(
              filteredPosts: realmPosts.filter { post in
                post.sort == "Active" &&
                  post.type == "All" &&
                  post.communityID == community.id &&
                  post.filterKey == "communitySpecific"
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
            CommunityRowView(community: community)
              .padding(.leading, -20)
          }
        }
      } label: {
        userSubscriptionsDisclosureGroupLabel
      }
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

  @ViewBuilder
  var debugModeView: some View {
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

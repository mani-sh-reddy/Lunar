//
//  SubscribedFeedQuicklink.swift
//  Lunar
//
//  Created by Mani on 20/09/2023.
//

import Defaults
import Foundation
import RealmSwift
import SwiftUI

struct SubscribedFeedQuicklink: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @Default(.activeAccount) var activeAccount

  var subscribedPostsQuicklink: Quicklink = DefaultQuicklinks().getSubscribedQuicklink()

  var body: some View {
    if activeAccount.actorID.isEmpty {
      HStack {
        Image(systemSymbol: .lockCircleFill)
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
          filteredPosts: realmPosts.filter { post in
            post.sort == subscribedPostsQuicklink.sort
              && post.type == subscribedPostsQuicklink.type
              && post.filterKey == "sortAndTypeOnly"
          },
          sort: subscribedPostsQuicklink.sort,
          type: subscribedPostsQuicklink.type,
          user: 0,
          communityID: 0,
          personID: 0,
          filterKey: "sortAndTypeOnly",
          heading: subscribedPostsQuicklink.title
        )
      } label: {
        HStack {
          Image(systemSymbol: .bookmarkCircleFill)
            .resizable()
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.purple)

          Text("Subscribed Feed")
            .padding(.horizontal, 10)
            .foregroundColor(.primary)
        }
      }
    }
  }
}

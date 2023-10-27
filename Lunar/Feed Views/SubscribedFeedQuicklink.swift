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
            post.sort == "Active" &&
              post.type == "Subscribed" &&
              post.filterKey == "sortAndTypeOnly"
          },
          sort: "Active",
          type: "Subscribed",
          user: 0,
          communityID: 0,
          personID: 0,
          filterKey: "sortAndTypeOnly",
          heading: subscribedPostsQuicklink.title
        )
//        PostsView(
//          postsFetcher: PostsFetcher(
//            sortParameter: subscribedPostsQuicklink.sort,
//            typeParameter: subscribedPostsQuicklink.type
//          ), title: subscribedPostsQuicklink.title
//        )
      } label: {
        GeneralCommunityQuicklinkButton(
          image: subscribedPostsQuicklink.icon,
          hexColor: subscribedPostsQuicklink.iconColor,
          title: subscribedPostsQuicklink.title,
          brightness: subscribedPostsQuicklink.brightness,
          saturation: subscribedPostsQuicklink.saturation
        )
      }
    }
  }
}

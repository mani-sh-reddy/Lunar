//
//  GeneralCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Defaults
import RealmSwift
import SwiftUI

struct GeneralCommunitiesView: View {
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.quicklinks) var quicklinks
  @Default(.lockedQuicklinks) var lockedQuicklinks

  var body: some View {
    ForEach(enableQuicklinks ? quicklinks : lockedQuicklinks, id: \.self) { quicklink in
      NavigationLink {
        PostsView(
          filteredPosts: realmPosts.filter { post in
            post.sort == quicklink.sort
              && post.type == quicklink.type
              && post.filterKey == "sortAndTypeOnly"
          },
          sort: quicklink.sort,
          type: quicklink.type,
          user: 0,
          communityID: 0,
          personID: 0,
          filterKey: "sortAndTypeOnly",
          heading: quicklink.title
        )
      } label: {
        GeneralCommunityQuicklinkButton(
          image: quicklink.icon,
          hexColor: quicklink.iconColor,
          title: quicklink.title,
          brightness: quicklink.brightness,
          saturation: quicklink.saturation,
          type: quicklink.type,
          sort: quicklink.sort
        )
      }
    }
  }
}

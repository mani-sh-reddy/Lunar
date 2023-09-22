//
//  GeneralCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Defaults
import SwiftUI

struct GeneralCommunitiesView: View {
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.quicklinks) var quicklinks
  @Default(.lockedQuicklinks) var lockedQuicklinks
  @Default(.forcedPostSort) var forcedPostSort

  var body: some View {
    ForEach(enableQuicklinks ? quicklinks : lockedQuicklinks, id: \.self) { quicklink in
      NavigationLink {
        PostsView(
          postsFetcher: PostsFetcher(
            sortParameter: enableQuicklinks ? quicklink.sort : forcedPostSort.rawValue,
            typeParameter: quicklink.type
          ),
          title: quicklink.title
        )
      } label: {
        GeneralCommunityQuicklinkButton(
          image: quicklink.icon,
          hexColor: quicklink.iconColor,
          title: quicklink.title,
          brightness: quicklink.brightness,
          saturation: quicklink.saturation
        )
      }
    }
  }
}

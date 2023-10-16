//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SwiftUI

struct FeedView: View {
  @Default(.selectedInstance) var selectedInstance
  @Default(.kbinActive) var kbinActive
  @Default(.kbinHostURL) var kbinHostURL
  @Default(.activeAccount) var activeAccount
  @Default(.quicklinks) var quicklinks
  @Default(.enableQuicklinks) var enableQuicklinks

  var subscribedCommunityListHeading: String {
    if !activeAccount.actorID.isEmpty {
      "\(URLParser.extractUsername(from: activeAccount.actorID))'s Subscribed Communities"
    } else {
      "Subscribed Communities"
    }
  }

  var body: some View {
    NavigationView {
      List {
        VStack(alignment: .leading, spacing: 10) {
          Text(selectedInstance)
            .bold()
            .padding(0)
          if kbinActive {
            Text(kbinHostURL)
              .bold()
              .foregroundStyle(
                LinearGradient(
                  gradient: Gradient(colors: [.purple, .pink]),
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .padding(0)
          }
        }.listRowBackground(Color.clear)
          .font(.largeTitle)
          .padding(0)

        if !quicklinks.isEmpty {
          Section(header: Text(enableQuicklinks ? "Quicklinks" : "Feed")) {
            GeneralCommunitiesView()
          }
        }

        if kbinActive {
          Section(header: Text("Kbin")) {
            KbinMagazinesSectionView()
          }
        }

        Section(header: Text("Trending")) {
          TrendingCommunitiesSectionView(communitiesFetcher: CommunitiesFetcher(limitParameter: 5))
          MoreCommunitiesButtonView()
        }
        Section(header: Text(subscribedCommunityListHeading)) {
          SubscribedCommunitiesSectionView(
            communitiesFetcher: CommunitiesFetcher(
              limitParameter: 50, sortParameter: "Active", typeParameter: "Subscribed"
            ))
        }
      }
      .navigationTitle("Home")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}

//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct FeedView: View {
  @Default(.selectedInstance) var selectedInstance
  @Default(.kbinActive) var kbinActive
  @Default(.kbinHostURL) var kbinHostURL
  @Default(.activeAccount) var activeAccount
  @Default(.quicklinks) var quicklinks
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.realmExperimentalViewEnabled) var realmExperimentalViewEnabled

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
        title

        if !quicklinks.isEmpty {
          Section(header: Text(enableQuicklinks ? "Quicklinks" : "Feed")) {
            GeneralCommunitiesView()
          }
        }

        if realmExperimentalViewEnabled {
          NavigationLink {
            PostsViewLink(sort: "Active", type: "All")
          } label: {
            RealmPostsViewLabel()
          }
        }

        kbinFeed
        trendingSection
        subscribedSection
      }
      .navigationTitle("Home")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  var title: some View {
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
  }

  var trendingSection: some View {
    Section(header: Text("Trending")) {
      TrendingCommunitiesSectionView(communitiesFetcher: CommunitiesFetcher(limitParameter: 5))
      MoreCommunitiesButtonView()
    }
  }

  var subscribedSection: some View {
    Section(header: Text(subscribedCommunityListHeading)) {
      SubscribedCommunitiesSectionView(
        communitiesFetcher: CommunitiesFetcher(
          limitParameter: 50, sortParameter: "Active", typeParameter: "Subscribed"
        ))
    }
  }

  @ViewBuilder
  var kbinFeed: some View {
    if kbinActive {
      Section(header: Text("Kbin")) {
        KbinMagazinesSectionView()
      }
    }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}

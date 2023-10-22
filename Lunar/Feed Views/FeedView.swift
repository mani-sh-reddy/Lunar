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

  @ObservedResults(RealmDataState.self) var realmDataState

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

        if realmExperimentalViewEnabled {
          NavigationLink {
            /// Checking if the realm data state object for the identifier (primary key) exists
            /// the object will not exist on the first run
            if let realmDataStateObject = realmDataState.where({
              /// This identifier (aka the primary key) is generated automatically when creating the RealmDataState object
              /// It uses the other variables passed in to generate it such as instance..etc
              /// here it is being filtered based on identifier - there can only be one
              /// so using .first
              $0.identifier == "INSTANCE:lemmy.world_SORT:Active_TYPE:All_USER:_COMMUNITY:_PERSON:"
            }).first {
              RPostsView(realmDataState: realmDataStateObject)
            } else {
              let _ = print("FetchingFetchingFetchingFetching")
              /// This is run if the object above is not found
              /// It runs the postfetcher, which then creates a realmDataStateObject
              /// subsequent runs will use the newly created realmDataStateObject
              let _ = RPostsFetcher(
                sortParameter: "Active",
                typeParameter: "All",
                currentPage: 1
              )
            }
          } label: {
            RPostsViewLabel()
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

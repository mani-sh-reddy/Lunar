//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive
  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID

  var subscribedCommunityListHeading: String {
    if !selectedActorID.isEmpty {
      return "\(URLParser.extractUsername(from: selectedActorID))'s Subscribed Communities"
    } else {
      return "Subscribed Communities"
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

        Section(header: Text("Feed")) {
          GeneralCommunitiesView()
          KbinMagazinesSectionView()
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

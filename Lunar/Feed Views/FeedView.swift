//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @StateObject var networkMonitor = NetworkMonitor()
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive
  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("subscribedCommunityIDs") var subscribedCommunityIDs = Settings.subscribedCommunityIDs

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

        Section(header: Text("Feed")) {
          GeneralCommunitiesView()
          KbinMagazinesSectionView()
        }
        Section(header: Text("Trending")) {
          TrendingCommunitiesSectionView(trendingCommunitiesFetcher: TrendingCommunitiesFetcher())
          MoreCommunitiesButtonView()
        }
        Section(header: Text("Subscribed")) {
          SubscribedCommunitiesSectionView(
            communitiesFetcher: CommunitiesFetcher(
              limitParameter: 50, sortParameter: "Active", typeParameter: "Subscribed"))
        }
      }
    }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}

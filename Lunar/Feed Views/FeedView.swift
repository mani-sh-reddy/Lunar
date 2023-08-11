//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @StateObject var networkMonitor = NetworkMonitor()
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive
  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL

  var body: some View {
    NavigationView {
      List {
        VStack(alignment: .leading, spacing: 10) {
          Text(instanceHostURL)
            .bold()
            .padding(0)
          if kbinActive {
            Text(kbinHostURL)
              .bold()
              .foregroundStyle(
                LinearGradient(
                  gradient: Gradient(
                    colors: [
                      .purple,
                      .pink
                    ]), startPoint: .topLeading, endPoint: .bottomTrailing)
              )
              .padding(0)
          }
        }.listRowBackground(Color.clear)
          .font(.largeTitle)

        Section(header: Text("Feed")) {
          AggregatedCommunitiesSectionView()
          KbinMagazinesSectionView()
        }
        Section(header: Text("Trending")) {
          TrendingCommunitiesSectionView(trendingCommunitiesFetcher: TrendingCommunitiesFetcher())
          MoreCommunitiesButtonView()
        }
        Section(header: Text("Subscribed")) {
          SubscribedCommunitiesSectionView()
        }
      }
    }
    .onAppear {
      networkMonitor.checkConnection()
    }
    .overlay(alignment: .bottom) {
      if networkMonitor.connected {
        EmptyView()
      } else {
        NoInternetConnectionView()
      }
    }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView()
  }
}

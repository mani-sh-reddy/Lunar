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

  @State var showingOfflineDownloaderPopover: Bool = false

  var subscribedCommunityListHeading: String {
    if !activeAccount.actorID.isEmpty {
      "\(URLParser.extractUsername(from: activeAccount.actorID))'s Communities"
    } else {
      "Subscribed Communities"
    }
  }

  var body: some View {
    NavigationView {
      List {
        if !quicklinks.isEmpty {
          Section(header: Text(enableQuicklinks ? "Links" : "Feed")) {
            GeneralCommunitiesView()
          }
        }
        kbinFeed
        subscribedSection
        trendingSection
        downloaderButton
      }
      .navigationTitle(kbinActive ? "Home" : selectedInstance)
      .navigationBarTitleDisplayMode(.large)
    }
    .popover(isPresented: $showingOfflineDownloaderPopover) {
      OfflineDownloaderView(presentingView: $showingOfflineDownloaderPopover)
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }

  var downloaderButton: some View {
    Section {
      Button {
        showingOfflineDownloaderPopover = true
      } label: {
        HStack {
          Image(systemSymbol: .arrowDownCircleFill)
            .resizable()
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.hierarchical)
            .foregroundColor(.indigo)

          Text("Offline Downloader")
            .padding(.horizontal, 10)
            .foregroundColor(.indigo)
        }
      }
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
      TrendingCommunitiesSectionView(communitiesFetcher: LegacyCommunitiesFetcher(limitParameter: 50))
      ExploreCommunitiesButton()
    }
  }

  var subscribedSection: some View {
    Section {
      SubscribedCommunitiesSectionView()
    } header: {
      Text(subscribedCommunityListHeading)
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

#Preview {
  FeedView(showingOfflineDownloaderPopover: true)
}

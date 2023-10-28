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
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  @Default(.selectedInstance) var selectedInstance
  @Default(.kbinActive) var kbinActive
  @Default(.kbinHostURL) var kbinHostURL
  @Default(.activeAccount) var activeAccount
  @Default(.quicklinks) var quicklinks
  @Default(.enableQuicklinks) var enableQuicklinks
  @Default(.realmExperimentalViewEnabled) var realmExperimentalViewEnabled

  @Environment(\.dismiss) var dismiss

  @State var showingOfflineDownloaderPopover: Bool = false
  @State var downloaderSort: String = "Active"
  @State var downloaderType: String = "All"
  @State var pagesToDownload: Int = 1
  @State var currentlyDownloadingPage: Int = 1
  @State var downloaderCommunityID: Int = 0

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

//        if realmExperimentalViewEnabled {
//          realmSection
//        }

        kbinFeed
        trendingSection
        subscribedSection

        downloaderButton
      }
      .navigationTitle("Home")
      .navigationBarTitleDisplayMode(.inline)
    }
    .popover(isPresented: $showingOfflineDownloaderPopover) {
      downloaderPopover
    }
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

  var downloaderPopover: some View {
    List {
      Section {
        HStack {
          Text("Downloader")
            .font(.title)
            .bold()
          Spacer()
          Button {
            dismiss()
          } label: {
            Image(systemSymbol: .xmarkCircleFill)
              .font(.largeTitle)
              .foregroundStyle(.secondary)
              .saturation(0)
          }
        }
      }
      .listRowBackground(Color.clear)

      Section {
        Text("Downloading Page \(currentlyDownloadingPage)/\(pagesToDownload)")
      }

      Section {
        Picker(selection: $downloaderSort, label: Text("Sort Query")) {
          Text("Active").tag("Active")
        }
        .pickerStyle(.menu)
        Picker(selection: $downloaderType, label: Text("Type Query")) {
          Text("All").tag("All")
        }
        .pickerStyle(.menu)
        Picker("Pages to Download", selection: $pagesToDownload) {
          ForEach(1 ..< 100) {
            Text("\($0) pages")
          }
        }
      }
      Section {
        Button {
          startDownload()
        } label: {
          Text("Download")
        }
      }
    }
  }

//  var realmSection: some View {
//    NavigationLink {
//      PostsView(
//        filteredPosts: realmPosts.filter { post in
//          post.sort == "Active" &&
//            post.type == "All" &&
//            post.filterKey == "sortAndTypeOnly"
//        },
//        sort: "Active",
//        type: "All",
//        user: 0,
//        communityID: 0,
//        personID: 0,
//        filterKey: "sortAndTypeOnly",
//        heading: "Realm Experiment"
//      )
//    } label: {
//      RealmPostsViewLabel()
//    }
//  }

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
      ExploreCommunitiesButton()
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

  func startDownload() {
    for page in 1 ... pagesToDownload {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        currentlyDownloadingPage = page
        PostsFetcher(
          sort: downloaderSort,
          type: downloaderType,
          communityID: 0,
          page: page,
          filterKey: "sortAndTypeOnly"
        ).loadContent()
      }
    }
  }
}

struct FeedView_Previews: PreviewProvider {
  static var previews: some View {
    FeedView(showingOfflineDownloaderPopover: true)
  }
}

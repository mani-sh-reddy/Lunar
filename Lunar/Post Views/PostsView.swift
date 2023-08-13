//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

//struct KbinThreadsView: View {
//  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL
//  @StateObject var kbinThreadsFetcher: KbinThreadsFetcher
//
//  @State var postURL: String = ""
//
//  var body: some View {
//    List {
//      if kbinThreadsFetcher.isLoading {
//        ProgressView().id(UUID())
//      } else {
//        ForEach(kbinThreadsFetcher.posts, id: \.id) { post in
//          Section {
//            ZStack {
//              KbinPostRowView(post: post)
//              NavigationLink {
//                KbinCommentsView(post: post, postURL: "https://\(kbinHostURL)\(post.postURL)")
//              } label: {
//                EmptyView()
//              }
//              .opacity(0)
//            }
//          }
//          .task {
//            kbinThreadsFetcher.loadMoreContentIfNeeded(currentItem: post)
//            postURL = post.postURL
//          }
//        }
//      }
//    }
//    .refreshable {
//      await kbinThreadsFetcher.refreshContent()
//    }
//    .navigationTitle("Kbin")
//    .navigationBarTitleDisplayMode(.inline)
//    .listStyle(.insetGrouped)
//  }
//}

struct PostsView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @StateObject var postsFetcher: PostsFetcher
  @State private var bannerFailedToLoad = false
  @State private var iconFailedToLoad = false

  var title: String?
  var community: CommunityElement?
  var navigationHeading: String { return community?.community.name ?? title ?? "" }
  var communityDescription: String? { return community?.community.description }
  var communityActorID: String { return community?.community.actorID ?? "" }
  var isCommunitySpecific: Bool { return community != nil }

  var hasBanner: Bool {
    community?.community.banner != "" && community?.community.banner != nil
  }
  var hasIcon: Bool {
    community?.community.icon != "" && community?.community.icon != nil
  }

  var body: some View {
    List {
      if isCommunitySpecific {
        CommunityHeaderView(community: community)
      }
      ForEach(postsFetcher.posts, id: \.post.id) { post in
        Section {
          ZStack {
            PostRowView(post: post)
            NavigationLink {
              CommentsView(post: post)
            } label: {
              EmptyView()
            }
            .opacity(0)
          }
          .task {
            postsFetcher.loadMoreContentIfNeeded(currentItem: post)
          }
        }
      }
      if postsFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .onChange(of: instanceHostURL) { _ in
      Task {
        await postsFetcher.refreshContent()
      }
    }
    .refreshable {
      await postsFetcher.refreshContent()
    }
    .navigationTitle(navigationHeading)
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
  }
}

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    /// need to set showing popover to a constant value
    PostsView(
      postsFetcher: PostsFetcher(
        sortParameter: "Hot",
        typeParameter: "All",
        communityID: 234
      ), title: "Title"
    )
  }
}

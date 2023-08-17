//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Combine
import Kingfisher
import SwiftUI

struct PostsView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @StateObject private var postsFetcher = PostsFetcher()
  @State private var bannerFailedToLoad = false
  @State private var iconFailedToLoad = false

  var title: String?
  var community: CommunityElement?
  var navigationHeading: String { return community?.community.name ?? title ?? "" }
  var communityDescription: String? { return community?.community.description }
  var communityActorID: String { return community?.community.actorID ?? "" }
  var isCommunitySpecific: Bool { return community != nil }

  var hasBanner: Bool {
    community?.community.banner != "" && community?.community.banner != nil  // skipcq: SW-P1006
  }
  var hasIcon: Bool {
    community?.community.icon != "" && community?.community.icon != nil  // skipcq: SW-P1006
  }

  var body: some View {
    List {
      if isCommunitySpecific {
        CommunityHeaderView(community: community)
      }
      ForEach(postsFetcher.posts, id: \.post.id) { post in
        PostSectionView(post: post).environmentObject(postsFetcher)
          .task {
            postsFetcher.loadMoreContentIfNeeded(currentItem: post)
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

//struct PostsView_Previews: PreviewProvider {
//  static var previews: some View {
//    /// need to set showing popover to a constant value
//    PostsView(
//      postsFetcher: PostsFetcher(
//        sortParameter: "Hot",
//        typeParameter: "All",
//        communityID: 234
//      ), title: "Title"
//    )
//  }
//}

struct PostSectionView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher

  @State var upvoted: Bool = false
  @State var downvoted: Bool = false

  var post: PostElement

  var body: some View {
    //    let _ = print("----------------------")
    //    let _ = print("UPVOTED \(post.post.name): \(upvoted)")
    //    let _ = print("DOWNVOTED \(post.post.name): \(downvoted)")
    //    let _ = print("----------------------")
    Section {
      ZStack {
        PostRowView(
          upvoted: $upvoted,
          downvoted: $downvoted,
          post: post
        ).environmentObject(postsFetcher)
        NavigationLink {
          CommentsView(
            commentsFetcher: CommentsFetcher(postID: post.post.id),
            upvoted: $upvoted,
            downvoted: $downvoted,
            post: post
          ).environmentObject(postsFetcher)
        } label: {
          EmptyView()
        }
        .opacity(0)
      }
    }
  }
}

class PostsFetcherMid: ObservableObject {
  @Published var posts: [PostElement] = []
}

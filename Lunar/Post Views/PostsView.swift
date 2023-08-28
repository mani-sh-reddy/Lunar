//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

struct PostsView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @StateObject var postsFetcher: PostsFetcher
  @State private var bannerFailedToLoad = false
  @State private var iconFailedToLoad = false

  var title: String?
  var community: CommunityElement?
  var user: UserElement?

  var isCommunitySpecific: Bool { return community != nil }
  var isUserSpecific: Bool { return user != nil }

  var hasBanner: Bool {
    if isCommunitySpecific {
      return community?.community.banner != "" && community?.community.banner != nil  // skipcq: SW-P1006
    } else if isUserSpecific {
      return user?.person.banner != "" && user?.person.banner != nil  // skipcq: SW-P1006
    } else {
      return false
    }
  }

  var hasIcon: Bool {
    if isCommunitySpecific {
      return community?.community.icon != "" && community?.community.icon != nil  // skipcq: SW-P1006
    } else if isUserSpecific {
      return user?.person.avatar != "" && user?.person.avatar != nil  // skipcq: SW-P1006
    } else {
      return false
    }
  }

  var navigationHeading: String {
    if isCommunitySpecific {
      return community?.community.name ?? ""
    } else if isUserSpecific {
      return user?.person.name ?? ""
    } else {
      return ""
    }
  }

  var communityDescription: String? { return community?.community.description }
  var communityActorID: String { return community?.community.actorID ?? "" }
  var communityBanner: String? { return community?.community.banner }
  var communityIcon: String? { return community?.community.icon }

  var userDescription: String? { return user?.person.bio }
  var userActorID: String { return user?.person.actorID ?? "" }
  var userBanner: String? { return user?.person.banner }
  var userIcon: String? { return user?.person.avatar }

  var body: some View {
    List {
      if isCommunitySpecific {
        HeaderView(
          navigationHeading: navigationHeading,
          description: communityDescription,
          actorID: communityActorID,
          banner: communityBanner,
          icon: communityIcon
        )
      }
      if isUserSpecific {
        HeaderView(
          navigationHeading: navigationHeading,
          description: userDescription,
          actorID: userActorID,
          banner: userBanner,
          icon: userIcon
        )
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

  var communityIsSubscribed: Bool {
    if post.subscribed == .subscribed {
      return true
    } else {
      return false
    }
  }

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
          isSubscribed: communityIsSubscribed, post: post
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

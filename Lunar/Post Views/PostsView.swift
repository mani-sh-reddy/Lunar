//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct PostsView: View {
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("compactViewEnabled") var compactViewEnabled = Settings.compactViewEnabled

  @StateObject var postsFetcher: PostsFetcher

  var title: String?
  var community: CommunityObject?
  var user: PersonObject?

  var isCommunitySpecific: Bool { community != nil }
  var isUserSpecific: Bool { user != nil }

  var navigationHeading: String {
    if isCommunitySpecific {
      return community?.community.name ?? ""
    }

    if isUserSpecific {
      return user?.person.name ?? ""
    }

    return title ?? ""
  }

  var communityDescription: String? { community?.community.description }
  var communityActorID: String { community?.community.actorID ?? "" }
  var communityBanner: String? { community?.community.banner }
  var communityIcon: String? { community?.community.icon }

  var userDescription: String? { user?.person.bio }
  var userActorID: String { user?.person.actorID ?? "" }
  var userBanner: String? { user?.person.banner }
  var userIcon: String? { user?.person.avatar }

  var body: some View {
    if compactViewEnabled {
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
        Divider()
      }
      .onChange(of: selectedInstance) { _ in
        Task {
          await postsFetcher.refreshContent()
        }
      }
      .refreshable {
        await postsFetcher.refreshContent()
      }
      .navigationTitle(navigationHeading)
      .navigationBarTitleDisplayMode(.inline)
      .listStyle(.plain)
    } else {
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
      .onChange(of: selectedInstance) { _ in
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
}

// struct PostsView_Previews: PreviewProvider {
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
// }

struct PostSectionView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher

  @State var upvoted: Bool = false
  @State var downvoted: Bool = false

  var post: PostObject

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

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    PostsView(postsFetcher: PostsFetcher())
  }
}

//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct PostsView: View {
  @Default(.forcedPostSort) var forcedPostSort
  @Default(.selectedInstance) var selectedInstance
  @Default(.postsViewStyle) var postsViewStyle
  @Default(.enableQuicklinks) var enableQuicklinks

  @StateObject var postsFetcher: PostsFetcher

  @State var showingCreatePostPopover: Bool = false

  var title: String?
  var community: CommunityObject?
  var user: PersonObject?

  var isCommunitySpecific: Bool { community != nil }
  var isUserSpecific: Bool { user != nil }

  var navigationHeading: String {
    isCommunitySpecific ? (community?.community.name ?? "") :
      isUserSpecific ? (user?.person.name ?? "") :
      (title ?? "")
  }

  var communityDescription: String? { community?.community.description }
  var communityID: Int { community?.community.id ?? 0 }
  var communityActorID: String { community?.community.actorID ?? "" }
  var communityName: String { community?.community.name ?? "" }
  var communityBanner: String? { community?.community.banner }
  var communityIcon: String? { community?.community.icon }
  var userDescription: String? { user?.person.bio }
  var userActorID: String { user?.person.actorID ?? "" }
  var userBanner: String? { user?.person.banner }
  var userIcon: String? { user?.person.avatar }

  var listStyle: String {
    if postsViewStyle == "compactPlain" {
      "plain"
    } else {
      postsViewStyle
    }
  }

  var body: some View {
    List {
      if isCommunitySpecific || isUserSpecific {
        HeaderView(
          navigationHeading: navigationHeading,
          description: isCommunitySpecific ? communityDescription : userDescription,
          actorID: isCommunitySpecific ? communityActorID : userActorID,
          banner: isCommunitySpecific ? communityBanner : userBanner,
          icon: isCommunitySpecific ? communityIcon : userIcon,
          isCommunitySpecific: isCommunitySpecific
        )
      }
      ForEach(postsFetcher.posts, id: \.post.id) { post in
        PostSectionView(post: post)
          .onAppear {
            if post.post.id == postsFetcher.posts.last?.post.id {
              postsFetcher.loadContent()
            }
          }
      }
      if postsFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      postsFetcher.loadContent(isRefreshing: true)
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        postsFetcher.loadContent(isRefreshing: true)
      }
    }
    .onChange(of: forcedPostSort) { _ in
      withAnimation {
        postsFetcher.sortParameter = forcedPostSort.rawValue
        postsFetcher.loadContent(isRefreshing: true)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        if isCommunitySpecific {
          Button {
            showingCreatePostPopover = true
          } label: {
            Image(systemSymbol: .rectangleStackBadgePlus)
          }
        }
      }
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        switch enableQuicklinks {
        case false:
          SortTypePickerView(sortType: $forcedPostSort)
        case true:
          EmptyView()
        }
      }
    }
    .popover(isPresented: $showingCreatePostPopover) {
      CreatePostPopoverView(
        showingCreatePostPopover: $showingCreatePostPopover,
        communityID: communityID,
        communityName: communityName,
        communityActorID: communityActorID
      )
    }
    .navigationTitle(navigationHeading)
    .navigationBarTitleDisplayMode(.inline)
    .modifier(ConditionalListStyleModifier(listStyle: listStyle))
  }
}

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    PostsView(postsFetcher: PostsFetcher())
  }
}

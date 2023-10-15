//
//  PersonPostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Defaults
import SwiftUI

struct PersonPostsView: View {
  @Default(.forcedPostSort) var forcedPostSort
  @Default(.selectedInstance) var selectedInstance
  @Default(.postsViewStyle) var postsViewStyle

  @StateObject var personFetcher: PersonFetcher

  var title: String?
  var community: CommunityObject?
  var user: PersonObject?

  var isCommunitySpecific: Bool { community != nil }
  var isUserSpecific: Bool { user != nil }

  var navigationHeading: String {
    if let title {
      title
    } else {
      "User"
    }
  }

  var communityDescription: String? { community?.community.description }
  var communityActorID: String { community?.community.actorID ?? "" }
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
          icon: isCommunitySpecific ? communityIcon : userIcon
        )
      }
      ForEach(personFetcher.posts, id: \.post.id) { post in
        PostSectionView(post: post)
          .onAppear {
            if post.post.id == personFetcher.posts.last?.post.id {
              personFetcher.loadContent()
            }
          }
      }
      if personFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      personFetcher.loadContent(isRefreshing: true)
    }
    .onChange(of: selectedInstance) { _ in
      Task {
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .onChange(of: forcedPostSort) { _ in
      withAnimation {
        personFetcher.sortParameter = forcedPostSort.rawValue
        personFetcher.loadContent(isRefreshing: true)
      }
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        SortTypePickerView(sortType: $forcedPostSort)
      }
    }
    .navigationTitle(navigationHeading)
    .navigationBarTitleDisplayMode(.inline)
    .modifier(ConditionalListStyleModifier(listStyle: listStyle))
  }
}

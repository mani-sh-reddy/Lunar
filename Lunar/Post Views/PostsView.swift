//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI
import Defaults

struct PostsView: View {
  @Default(.postSortType) var postSortType
  @AppStorage("selectedInstance") var selectedInstance = Settings.selectedInstance
  @AppStorage("compactViewEnabled") var compactViewEnabled = Settings.compactViewEnabled

  @StateObject var postsFetcher: PostsFetcher

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
  var communityActorID: String { community?.community.actorID ?? "" }
  var communityBanner: String? { community?.community.banner }
  var communityIcon: String? { community?.community.icon }
  var userDescription: String? { user?.person.bio }
  var userActorID: String { user?.person.actorID ?? "" }
  var userBanner: String? { user?.person.banner }
  var userIcon: String? { user?.person.avatar }

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
      ForEach(postsFetcher.posts, id: \.post.id) { post in
        PostSectionView(post: post)
          .onAppear {
            if post.post.id == postsFetcher.posts.last?.post.id {
              postsFetcher.loadContent()
            }
          }
          .environmentObject(postsFetcher)
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
    .onChange(of: postSortType) { query in
      withAnimation {
        postsFetcher.sortParameter = postSortType.rawValue
        postsFetcher.loadContent(isRefreshing: true)
        }
      }
//    .toolbar {
//      ToolbarItem(placement: .topBarTrailing) {
//        SortTypePickerView(sortType: $postSortType)
//      }
//    }
    .navigationTitle(navigationHeading)
    .navigationBarTitleDisplayMode(.inline)
    .modifier(ConditionalListStyleModifier(listStyle: compactViewEnabled ? "plain" : "insetGrouped"))
  }
}

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    PostsView(postsFetcher: PostsFetcher())
  }
}

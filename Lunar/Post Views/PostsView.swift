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
  
  @ObservedObject var postsFetcher: PostsFetcher
  
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
  
//  var listStyle: List {
//    compactViewEnabled ? .plain : .insetGrouped
//  }
  
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
            print(post.creator.name)
//            print("comparing CURRENT: \(post.post.id) with LAST: \(String(describing: postsFetcher.posts.last?.post.id))")
            if post.post.id == postsFetcher.posts.last?.post.id {
              print("LOAD MORE HERE -----------------------------------")
              postsFetcher.loadContent()
            }
          }
          .environmentObject(postsFetcher)
      }
//      ForEach(postsFetcher.posts, id: \.post.id) { post in
//        PostSectionView(post: post)
//          .onAppear {
//            postsFetcher.loadMoreContentIfNeeded(currentItem: post)
//          }
//          .environmentObject(postsFetcher)
//      }
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
    
    .navigationTitle(navigationHeading)
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
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

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    PostsView(postsFetcher: PostsFetcher())
  }
}

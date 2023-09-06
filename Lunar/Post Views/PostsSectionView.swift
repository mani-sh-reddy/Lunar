//
//  PostsSectionView.swift
//  Lunar
//
//  Created by Mani on 06/09/2023.
//

import Foundation
import SwiftUI

struct PostSectionView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  
  @State var upvoted: Bool = false
  @State var downvoted: Bool = false
  
  var post: PostObject
  
  var communityIsSubscribed: Bool {
    post.subscribed == .subscribed
  }
  
  var body: some View {
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

//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import SwiftUI

struct CommentsView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

  var post: PostObject

  var body: some View {
    if commentsFetcher.isLoading {
      ProgressView()
    } else {
      CommentSectionView(
        post: post,
        comments: commentsFetcher.comments,
        postBody: post.post.body ?? "",
        upvoted: $upvoted,
        downvoted: $downvoted
      )
      .environmentObject(postsFetcher)
      .environmentObject(commentsFetcher)
    }
  }
}

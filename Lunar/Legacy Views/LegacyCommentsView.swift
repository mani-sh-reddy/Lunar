//
//  LegacyCommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import SFSafeSymbols
import SwiftUI

struct LegacyCommentsView: View {
  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  @State var showingCommentPopover = false
  @State var replyingTo = Comment(content: "", published: "", apID: "", path: "", id: 0, creatorID: 0, postID: 0, languageID: 0, removed: false, deleted: false, local: true, distinguished: false, updated: nil)

  var post: PostObject

  var body: some View {
    if commentsFetcher.isLoading {
      ProgressView()
    } else {
      LegacyCommentSectionView(
        post: post,
        comments: commentsFetcher.comments,
        postBody: post.post.body ?? "",
        replyingTo: $replyingTo,
        upvoted: $upvoted,
        downvoted: $downvoted,
        showingCommentPopover: $showingCommentPopover
      )
      .popover(isPresented: $showingCommentPopover) {
        if replyingTo.id == 0 {
          CommentsViewWorkaroundWarning()
        } else {
          LegacyCommentPopoverView(
            showingCommentPopover: $showingCommentPopover,
            post: post.post,
            comment: replyingTo
          )
          .environmentObject(commentsFetcher)
        }
      }
      .environmentObject(commentsFetcher)
    }
  }
}

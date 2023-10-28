//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import SFSafeSymbols
import SwiftUI

struct CommentsView: View {
  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  @State var showingCommentPopover = false
  @State var replyingTo = Comment(content: "", published: "", apID: "", path: "", id: 0, creatorID: 0, postID: 0, languageID: 0, removed: false, deleted: false, local: true, distinguished: false, updated: nil)

  var post: RealmPost

  var body: some View {
    List {
      Section {
        CompactPostItem(post: post)
          .padding(.horizontal, -5)
      }
      Section {
        if commentsFetcher.isLoading {
          ProgressView()
        } else {
          CommentSectionView(
            post: post,
            comments: commentsFetcher.comments,
            postBody: post.postBody ?? "",
            replyingTo: $replyingTo,
            upvoted: $upvoted,
            downvoted: $downvoted,
            showingCommentPopover: $showingCommentPopover
          )
          .popover(isPresented: $showingCommentPopover) {
            if replyingTo.id == 0 {
              CommentsViewWorkaroundWarning()
            } else {
              CommentPopoverView(
                showingCommentPopover: $showingCommentPopover,
                post: post,
                comment: replyingTo
              )
              .environmentObject(commentsFetcher)
            }
          }
          .environmentObject(commentsFetcher)
        }
      }
    }
    .listStyle(.grouped)
  }
}

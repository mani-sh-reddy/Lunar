//
//  LegacyCommentSectionView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SFSafeSymbols
import SwiftUI

struct LegacyCommentSectionView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  var post: PostObject
  var comments: [CommentObject]
  var postBody: String

  @State var collapseToIndex: Int = 0
  @State var collapserPath: String = ""

  @Binding var replyingTo: Comment
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  @Binding var showingCommentPopover: Bool

  var communityIsSubscribed: Bool {
    if post.subscribed == .subscribed {
      true
    } else {
      false
    }
  }

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    List {
      postSection
      recursiveCommentSection
    }
    .listStyle(.grouped)
  }

  var recursiveCommentSection: some View {
    let nestedComments = comments.nestedComment
    return Section {
      ForEach(nestedComments, id: \.id) { comment in
        LegacyRecursiveComment(showingCommentPopover: $showingCommentPopover, replyingTo: $replyingTo, nestedComment: comment, post: post.post).id(UUID())
      }
    }
  }

  var postSection: some View {
    Section {
      LegacyPostRowView(
        upvoted: $upvoted, downvoted: $downvoted, isSubscribed: communityIsSubscribed, post: post, insideCommentsView: true
      )
      LegacyInPostActionsView(post: post)
      if !postBody.isEmpty {
        VStack(alignment: .trailing) {
//          Text(try! AttributedString(styledMarkdown: postBody)).font(.body)
          ExpandableTextBox(LocalizedStringKey(postBody))
        }
      }
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }
}

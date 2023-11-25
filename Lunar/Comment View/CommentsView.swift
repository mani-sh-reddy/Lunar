//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Defaults
import MarkdownUI
import SFSafeSymbols
import SwiftUI

struct CommentsView: View {
  @Default(.activeAccount) var activeAccount

  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  @State var showingCreateCommentPopover = false
  @State var postBodyExpanded = false

  var post: RealmPost

  var body: some View {
    List {
      postSection
      commentsSection
    }
    .listStyle(.grouped)
//    .navigationTitle(post.postName)
//    .toolbar {
//      ToolbarItemGroup(placement: .navigationBarTrailing) {
//        if !activeAccount.userID.isEmpty {
//          createCommentTopLevelButton
//        }
//      }
//    }
//    .popover(isPresented: $showingCreateCommentPopover) {
//      commentPopoverAction
//    }
    .environmentObject(commentsFetcher)
  }

  var commentsSection: some View {
    Section {
      if commentsFetcher.isLoading {
        ProgressView()
      } else {
        let nestedComments = commentsFetcher.comments.nestedComment
        ForEach(nestedComments, id: \.id) { comment in
          RecursiveComment(
            nestedComment: comment,
            post: post
          )
        }
      }
    }
  }

  var postSection: some View {
    Section {
      CompactPostItem(post: post, parentView: "CommentsView")
        .padding(.horizontal, -5)
      if let postBody = post.postBody, !postBody.isEmpty {
        DisclosureGroup(isExpanded: $postBodyExpanded) {
          Markdown { postBody }
        } label: {
          if postBodyExpanded {
            Text("")
          } else {
            Text(postBody)
              .italic()
              .foregroundStyle(.gray)
              .lineLimit(3)
              .font(.caption)
          }
        }
      }
    }
  }

//  @ViewBuilder
//  var commentPopoverAction: some View {
//    CreateCommentPopover(
//      post: post,
//      parentString: post.postName
//    )
//    .environmentObject(commentsFetcher)
//  }
//
//  var createCommentTopLevelButton: some View {
//    Button {
//      showingCreateCommentPopover = true
//    } label: {
//      Image(systemSymbol: .plusBubbleFill)
//    }
//  }
}

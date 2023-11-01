//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

struct CommentsView: View {
  @Default(.activeAccount) var activeAccount

  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  @State var showingCreateCommentPopover = false

  var post: RealmPost

  var body: some View {
    List {
      postSection
      commentsSection
    }
    .listStyle(.grouped)
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        if !activeAccount.userID.isEmpty {
          createCommentTopLevelButton
        }
      }
    }
    .popover(isPresented: $showingCreateCommentPopover) {
      commentPopoverAction
    }
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
      CompactPostItem(post: post)
        .padding(.horizontal, -5)
    }
  }

  @ViewBuilder
  var commentPopoverAction: some View {
    CreateCommentPopover(
      post: post,
      parentString: post.postName
    )
    .environmentObject(commentsFetcher)
  }

  var createCommentTopLevelButton: some View {
    Button {
      showingCreateCommentPopover = true
    } label: {
      Image(systemSymbol: .plusBubbleFill)
    }
  }
}

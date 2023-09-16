//
//  CommentSectionView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SwiftUI

struct CommentSectionView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  var post: PostObject
  var comments: [CommentObject]
  var postBody: String

  @State var collapseToIndex: Int = 0
  @State var collapserPath: String = ""

  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

  var communityIsSubscribed: Bool {
    if post.subscribed == .subscribed {
      return true
    } else {
      return false
    }
  }

  var body: some View {
    List {
      Section {
        PostRowView(
          upvoted: $upvoted, downvoted: $downvoted, isSubscribed: communityIsSubscribed, post: post, insideCommentsView: true
        ).environmentObject(postsFetcher)
        InPostActionsView(post: post)
        if !postBody.isEmpty {
          VStack(alignment: .trailing) {
            Text(try! AttributedString(styledMarkdown: postBody)).font(.body)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
      Section {
        ForEach(comments.indices, id: \.self) { index in
          let comment = comments[index]
          if !comment.isCollapsed, !comment.isShrunk {
            CommentRowView(
              collapseToIndex: $collapseToIndex,
              collapserPath: $collapserPath,
              comment: comment,
              listIndex: index,
              comments: comments
            ).id(UUID())
              .environmentObject(commentsFetcher)
          } else if !comment.isCollapsed, comment.isShrunk {
            HStack {
              Text("Collapsed").italic().foregroundStyle(.secondary).font(.caption)
              Spacer()
            }
            .contentShape(Rectangle())
            .onTapGesture {
              commentExpandAction(comment: comment)
            }
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
              Button {
                commentExpandAction(comment: comment)
              } label: {
                Label("expand", systemImage: "arrow.up.left.and.arrow.down.right.circle.fill")
              }
              .tint(.blue)
            }
          }
        }
      }
    }
    .listStyle(.grouped)
  }

  func commentExpandAction(comment: CommentObject) {
    withAnimation(.easeInOut) {
      for commentOnMainList in comments {
        if commentOnMainList.comment.path.contains(comment.comment.path) {
          if commentOnMainList.comment.path != comment.comment.path {
            commentsFetcher.updateCommentCollapseState(commentOnMainList, isCollapsed: false)
          } else {
            commentsFetcher.updateCommentShrinkState(commentOnMainList, isShrunk: false)
          }
        }
      }
    }
  }
}

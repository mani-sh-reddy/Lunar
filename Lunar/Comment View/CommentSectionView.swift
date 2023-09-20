//
//  CommentSectionView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SFSafeSymbols
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
      true
    } else {
      false
    }
  }

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    List {
      postSection
//      commentSection
      recursiveCommentSection
    }
    .listStyle(.grouped)
  }

//  var commentSection: some View {
//    Section {
//      ForEach(comments.indices, id: \.self) { index in
//        let comment = comments[index]
//        if !comment.isCollapsed, !comment.isShrunk {
//          CommentRowView(
//            collapseToIndex: $collapseToIndex,
//            collapserPath: $collapserPath,
//            comment: comment,
//            listIndex: index,
//            comments: comments
//          )
//          .id(UUID())
//          .environmentObject(commentsFetcher)
//        } else if !comment.isCollapsed, comment.isShrunk {
//          HStack {
//            Text(comment.comment.content) /// Collapsed (isShrunk) State
//              .italic()
//              .lineLimit(1)
//              .foregroundStyle(.secondary)
//              .font(.caption)
//            Spacer()
//            if let commentChildCount = comment.counts.childCount {
//              if commentChildCount > 0 {
//                Text(String(commentChildCount))
//                  .bold()
//                  .font(.caption)
//                  .fixedSize()
//                  .foregroundStyle(.gray)
//                Spacer().frame(width: 10)
//              }
//            }
//            Image(systemSymbol: .chevronForward)
//              .foregroundStyle(.blue)
//          }
//          .contentShape(Rectangle())
//          .onTapGesture {
//            haptics.impactOccurred(intensity: 0.5)
//            commentExpandAction(comment: comment)
//          }
//          .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//            Button {
//              haptics.impactOccurred(intensity: 0.5)
//              commentExpandAction(comment: comment)
//            } label: {
//              Label("expand", systemImage: "arrow.up.left.and.arrow.down.right.circle.fill")
//            }
//            .tint(.blue)
//          }
//        }
//      }
//    }
//  }
  var recursiveCommentSection: some View {
    let nestedComments = comments.nestedComment
    return Section {
      ForEach(nestedComments, id: \.id) { comment in
        RecursiveComment(nestedComment: comment, post: post.post).id(UUID())
      }
    }
  }

  var postSection: some View {
    Section {
      PostRowView(
        upvoted: $upvoted, downvoted: $downvoted, isSubscribed: communityIsSubscribed, post: post, insideCommentsView: true
      )
      .environmentObject(postsFetcher)
      InPostActionsView(post: post)
      if !postBody.isEmpty {
        VStack(alignment: .trailing) {
          Text(try! AttributedString(styledMarkdown: postBody)).font(.body)
        }
      }
    }
    .listRowSeparator(.hidden)
    .listRowBackground(Color.clear)
  }

//  func commentExpandAction(comment: CommentObject) {
//    withAnimation(.linear(duration: 0.3)) {
//      for commentOnMainList in comments {
//        if commentOnMainList.comment.path.contains(comment.comment.path) {
//          if commentOnMainList.comment.path != comment.comment.path {
//            // Expand or collapse other comments as needed
//            commentsFetcher.updateCommentCollapseState(commentOnMainList, isCollapsed: false)
//          } else {
//            // Toggle the collapse state of the clicked comment
//            commentsFetcher.updateCommentCollapseState(commentOnMainList, isCollapsed: !commentOnMainList.isCollapsed)
//          }
//        }
//      }
//    }
//  }
}

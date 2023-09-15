//
//  CommentSectionView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SwiftUI

struct CommentSectionView: View {
//  @EnvironmentObject var postsFetcher: PostsFetcher
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
    let nestedComments = comments.nestedComment

    List {
      Section {
        PostRowView(
          upvoted: $upvoted, downvoted: $downvoted, isSubscribed: communityIsSubscribed, post: post, insideCommentsView: true
        )
        //        .environmentObject(postsFetcher)
        InPostActionsView(post: post)
        if !postBody.isEmpty {
          VStack(alignment: .trailing) {
            ExpandableTextBox(LocalizedStringKey(postBody)).font(.body)
          }
        }
      }
      Section {
        ForEach(nestedComments, id: \.id) { comment in
          RecursiveComment(nestedComment: comment).id(UUID())
        }
      }
    }
    .listStyle(.grouped)
  }
}

struct RecursiveComment: View {
  @State private var isExpanded = true

  let commentHierarchyColors: [Color] = [
    .clear,
    .red,
    .orange,
    .yellow,
    .green,
    .cyan,
    .blue,
    .indigo,
    .purple,
  ]

  let nestedComment: NestedComment

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    if isExpanded {
      let indentLevel = min(nestedComment.indentLevel, commentHierarchyColors.count - 1)
      let color = commentHierarchyColors[indentLevel]

      HStack {
        if nestedComment.indentLevel > 1 {
          Rectangle()
            .foregroundColor(color)
            .frame(width: 2)
            .padding(.vertical, 5)
        }
        Text(try! AttributedString(markdown: nestedComment.commentViewData.comment.content))
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isExpanded.toggle()
        haptics.impactOccurred(intensity: 0.5)
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        swipeActions
      }

      ForEach(nestedComment.subComments, id: \.id) { subComment in
        RecursiveComment(nestedComment: subComment).id(UUID())
          .padding(.leading, 10) // Add indentation
      }
    } else {
      HStack {
        Text(try! AttributedString(markdown: "_Collapsed_"))
          .foregroundStyle(.gray)
          .font(.caption)
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isExpanded.toggle()
        haptics.impactOccurred(intensity: 0.5)
      }
    }
  }

  var swipeActions: some View {
    return Group {
      Button {
        isExpanded.toggle()
        haptics.impactOccurred(intensity: 0.5)
      } label: {
        Label("collapse", systemImage: "arrow.up.to.line.circle.fill")
      }
      .tint(.blue)
      Button {
        //        showCommentPopover = true
      } label: {
        Label("reply", systemImage: "arrowshape.turn.up.left.circle.fill")
      }.tint(.orange)
    }
  }
}

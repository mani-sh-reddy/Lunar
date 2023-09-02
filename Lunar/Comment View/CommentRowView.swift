//
//  CommentRowView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SwiftUI

struct CommentRowView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings
    .commentMetadataPosition
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @Binding var collapseToIndex: Int
  @Binding var collapserPath: String
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false
  @State var showCommentPopover: Bool = false

  var comment: CommentObject
  let listIndex: Int
  var comments: [CommentObject]

  var indentLevel: Int {
    let elements = comment.comment.path.split(separator: ".").map { String($0) }
    let elementCount = elements.isEmpty ? 1 : elements.count - 1
    if elementCount >= 1 {
      return elementCount
    } else {
      return 1
    }
  }

  let commentHierarchyColors: [Color] = [
    .red,
    .orange,
    .yellow,
    .green,
    .cyan,
    .blue,
    .indigo,
    .purple,
  ]

  var body: some View {
    HStack {
      if debugModeEnabled {
        Text(String(listIndex))
      }
      ForEach(1 ..< indentLevel, id: \.self) { _ in
        Rectangle().opacity(0).frame(width: 0.1).padding(.horizontal, 0)
      }
      let indentLevel = min(indentLevel, commentHierarchyColors.count - 1)
      let foregroundColor = commentHierarchyColors[indentLevel]
      if indentLevel > 1 {
        Capsule(style: .continuous)
          .foregroundStyle(foregroundColor)
          .frame(width: 1)
          .padding(0)
      }
      VStack(alignment: .leading, spacing: 3) {
        if commentMetadataPosition == "Bottom" {
          Text(LocalizedStringKey(comment.comment.content))
          CommentMetadataView(
            comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted
          )
          .environmentObject(commentsFetcher)
        } else if commentMetadataPosition == "Top" {
          CommentMetadataView(
            comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted
          )
          .environmentObject(commentsFetcher)
          Text(LocalizedStringKey(comment.comment.content))
        } else {
          Text(LocalizedStringKey(comment.comment.content))
        }
      }
    }.contentShape(Rectangle())
      .onTapGesture {
        commentCollapseAction()
      }
      .sheet(
        isPresented: $showCommentPopover,
        onDismiss: {
          Task {
            print("COMMENT SHEET DISMISSED")
            await commentsFetcher.refreshContent()
          }
        }
      ) {
        CommentPopoverView(
          showCommentPopover: $showCommentPopover,
          post: comment.post
        )
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button {
          commentCollapseAction()
        } label: {
          Label("collapse", systemImage: "arrow.up.to.line.circle.fill")
        }
        .tint(.blue)
        Button {
          showCommentPopover = true
        } label: {
          Label("reply", systemImage: "arrowshape.turn.up.left.circle.fill")
        }.tint(.orange)
      }
  }

  func commentCollapseAction() {
    withAnimation(.easeInOut) {
      if comment.isCollapsed {
        commentsFetcher.updateCommentCollapseState(comment, isCollapsed: false)
      } else {
        for commentMainList in comments {
          if commentMainList.comment.path.contains(comment.comment.path) {
            if commentMainList.comment.path != comment.comment.path {
              commentsFetcher.updateCommentCollapseState(commentMainList, isCollapsed: true)
            } else {
              commentsFetcher.updateCommentShrinkState(commentMainList, isShrunk: true)
            }
          }
        }
        collapseToIndex = listIndex
        collapserPath = comment.comment.path
      }
    }
  }
}

// struct CollapseCommentsSwipeAction: View {
//  //  @Binding var isClicked: Bool
//  @Binding var collapseToIndex: Int
//  @Binding var collapserPath: String
//  var listIndex: Int
//
//  var body: some View {
//    Button {
//      print("SWIPED")
//      withAnimation(.smooth) {
//        self.collapseToIndex = listIndex
//        self.collapserPath = comment.comment.path
//      }
//    } label: {
//      Image(systemName: "arrow.up.to.line.circle.fill")
//    }
//    .tint(.blue)
//  }
// }

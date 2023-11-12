//
//  RecursiveComment.swift
//  Lunar
//
//  Created by Mani on 16/09/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct RecursiveComment: View {
  @Default(.commentMetadataPosition) var commentMetadataPosition

  @State private var isExpanded = true
  @State var showCreateCommentPopover = false
  @EnvironmentObject var commentsFetcher: CommentsFetcher

  let nestedComment: NestedComment
  let post: RealmPost

  let commentHierarchyColors: [Color] = [
    .clear, .red, .orange, .yellow, .green, .cyan, .blue, .indigo, .purple,
  ]

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    if !nestedComment.commentViewData.isCollapsed {
      HStack {
        commentNestedLevelIndicator
        commentRow
        Spacer()
      }
      .fullScreenCover(isPresented: $showCreateCommentPopover) {
        commentPopoverAction
      }
      .contentShape(Rectangle())
      .onTapGesture { minimiseComment() }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        minimiseButton
        replyButton
      }
      .contextMenu {
        shareButton
      }

      ForEach(nestedComment.subComments, id: \.id) { subComment in
        RecursiveComment(
          nestedComment: subComment,
          post: post
        )
        .padding(.leading, 10) // Add indentation
      }
    } else {
      minimisedCommentStyle
        .contentShape(Rectangle())
        .onTapGesture { maximiseComment() }
    }
  }

  var shareButton: some View {
    Button {
      let items: [Any] = [nestedComment.commentViewData.comment.content]
      ShareSheet().share(items: items)
    } label: {
      Label("Share", systemSymbol: AllSymbols().shareContextIcon)
    }
  }

  var minimisedCommentStyle: some View {
    HStack {
      Text(try! AttributedString(styledMarkdown: "\(nestedComment.commentViewData.comment.content)"))
        .italic()
        .lineLimit(1)
        .foregroundStyle(.gray)
        .font(.caption)
      Spacer()
      if countSubcomments(nestedComment.subComments) > 0 {
        Text(String(countSubcomments(nestedComment.subComments)))
          .bold()
          .font(.caption)
          .fixedSize()
          .foregroundStyle(.gray)
        Spacer().frame(width: 10)
      }
      Image(systemSymbol: .chevronForward)
        .foregroundStyle(.blue)
    }
  }

  var replyButton: some View {
    Button {
      showCreateCommentPopover = true
    } label: {
      Label("reply", systemSymbol: AllSymbols().replyContextIcon)
    }
    .tint(.indigo)
  }

  var minimiseButton: some View {
    Button {
      isExpanded.toggle()
      haptics.impactOccurred(intensity: 0.5)
      commentsFetcher.updateCommentCollapseState(
        nestedComment.commentViewData, isCollapsed: true
      )
      print("swipe action collapse clicked")
    } label: {
      Label("collapse", systemSymbol: AllSymbols().minimiseContextIcon)
    }
    .tint(.blue)
  }

  func minimiseComment() {
    isExpanded.toggle()
    haptics.impactOccurred(intensity: 0.5)
    commentsFetcher.updateCommentCollapseState(nestedComment.commentViewData, isCollapsed: true)
    print("tapped to collapse")
  }

  func maximiseComment() {
    isExpanded.toggle()
    haptics.impactOccurred(intensity: 0.5)
    commentsFetcher.updateCommentCollapseState(
      nestedComment.commentViewData, isCollapsed: false
    )
    print("tapped to expand")
  }

  @ViewBuilder
  var commentNestedLevelIndicator: some View {
    let indentLevel = min(nestedComment.indentLevel, commentHierarchyColors.count - 1)
    let color = commentHierarchyColors[indentLevel]
    if nestedComment.indentLevel > 1 {
      Rectangle()
        .foregroundColor(color)
        .frame(width: 2)
        .padding(.vertical, 5)
    }
  }

  @ViewBuilder
  var commentPopoverAction: some View {
    CreateCommentPopover(
      post: post,
      parentID: nestedComment.commentID,
      parentString: nestedComment.commentViewData.comment.content
    )
    .id(nestedComment.commentViewData.comment.id)
    .environmentObject(commentsFetcher)
  }

  var commentRow: some View {
    VStack(alignment: .leading) {
      if commentMetadataPosition == "Top" {
        commentMetadata
      }
      Text(try! AttributedString(styledMarkdown: nestedComment.commentViewData.comment.content))
      if commentMetadataPosition == "Bottom" {
        commentMetadata
      }
    }
  }

  var commentMetadata: some View {
    CommentMetadataView(comment: nestedComment.commentViewData)
      .environmentObject(commentsFetcher)
  }

  func countSubcomments(_ nestedComments: [NestedComment]) -> Int {
    var count = 0

    for comment in nestedComments {
      count += 1 // Count the current comment
      count += countSubcomments(comment.subComments)
    }

    return count
  }
}

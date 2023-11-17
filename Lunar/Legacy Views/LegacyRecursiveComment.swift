//
//  LegacyRecursiveComment.swift
//  Lunar
//
//  Created by Mani on 16/09/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

struct LegacyRecursiveComment: View {
  @Default(.commentMetadataPosition) var commentMetadataPosition
  @Default(.activeAccount) var activeAccount

  @State private var isExpanded = true
  @Binding var showingCommentPopover: Bool
  @Binding var replyingTo: Comment
  //  @State var commentText: String = ""
  @EnvironmentObject var commentsFetcher: CommentsFetcher

  let nestedComment: NestedComment
  let post: Post

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

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    if !nestedComment.commentViewData.isCollapsed {
      let indentLevel = min(nestedComment.indentLevel, commentHierarchyColors.count - 1)
      let color = commentHierarchyColors[indentLevel]
      HStack {
        if nestedComment.indentLevel > 1 {
          Rectangle()
            .foregroundColor(color)
            .frame(width: 2)
            .padding(.vertical, 5)
        }
        commentRow
        Spacer()
      }
      .contentShape(Rectangle())
      .onTapGesture {
        isExpanded.toggle()
        haptics.impactOccurred(intensity: 0.5)
        commentsFetcher.updateCommentCollapseState(nestedComment.commentViewData, isCollapsed: true)
        print("tapped to collapse")
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Group {
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
          if !activeAccount.actorID.isEmpty {
            Button {
              replyingTo = nestedComment.commentViewData.comment
              showingCommentPopover = true
            } label: {
              Label("reply", systemSymbol: AllSymbols().replyContextIcon)
            }
            .tint(.orange)
          }
        }
      }

      ForEach(nestedComment.subComments, id: \.id) { subComment in
        LegacyRecursiveComment(
          showingCommentPopover: $showingCommentPopover,
          replyingTo: $replyingTo,
          nestedComment: subComment,
          post: post
        )
        .id(UUID())
        .padding(.leading, 10) // Add indentation

        //          .sheet(isPresented: $showingCommentPopover) {
        //            let _ = print("POPOVER CLICKED")
        //            CommentPopoverView(
        //              showingCommentPopover: $showingCommentPopover,
        //              post: post,
        //              comment: nestedComment.commentViewData.comment
        //            )
        //            .environmentObject(commentsFetcher)
        //          }
      }
    } else {
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
      .contentShape(Rectangle())
      .onTapGesture {
        isExpanded.toggle()
        haptics.impactOccurred(intensity: 0.5)
        commentsFetcher.updateCommentCollapseState(
          nestedComment.commentViewData, isCollapsed: false
        )
        print("tapped to expand")
      }
    }
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

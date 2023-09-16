////
////  CommentRowView.swift
////  Lunar
////
////  Created by Mani on 18/08/2023.
////
//
//import SwiftUI
//
//struct CommentRowView: View {
//  @EnvironmentObject var commentsFetcher: CommentsFetcher
//  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings
//    .commentMetadataPosition
//  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
//  @Binding var collapseToIndex: Int
//  @Binding var collapserPath: String
//  @State var commentUpvoted: Bool = false
//  @State var commentDownvoted: Bool = false
//  @State var showingCommentPopover: Bool = false
//
//  var comment: CommentObject
//  let listIndex: Int
//  var comments: [CommentObject]
//
//  var indentLevel: Int {
//    let elements = comment.comment.path.split(separator: ".").map { String($0) }
//    let elementCount = elements.isEmpty ? 1 : elements.count - 1
//    if elementCount >= 1 {
//      return elementCount
//    } else {
//      return 1
//    }
//  }
//
//  let commentHierarchyColors: [Color] = [
//    .red,
//    .orange,
//    .yellow,
//    .green,
//    .cyan,
//    .blue,
//    .indigo,
//    .purple,
//  ]
//
//  var body: some View {
//    HStack {
//      if debugModeEnabled {
//        Text(String(listIndex))
//      }
//      ForEach(1 ..< indentLevel, id: \.self) { _ in
//        Rectangle().opacity(0).frame(width: 0.1).padding(.horizontal, 0)
//      }
//      let indentLevel = min(indentLevel, commentHierarchyColors.count - 1)
//      let foregroundColor = commentHierarchyColors[indentLevel]
//      if indentLevel > 1 {
//        Capsule(style: .continuous)
//          .foregroundStyle(foregroundColor)
//          .frame(width: 1)
//          .padding(0)
//      }
//      VStack(alignment: .leading, spacing: 3) {
//        if commentMetadataPosition == "Bottom" {
//          commentBody
//          commentMetadata
//        } else if commentMetadataPosition == "Top" {
//          commentMetadata
//          commentBody
//        } else {
//          commentBody
//        }
//      }
//    }
//    .contentShape(Rectangle())
//    .onTapGesture {
//      commentCollapseAction()
//    }
//    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//      Button {
//        commentCollapseAction()
//      } label: {
//        Label("collapse", systemImage: "arrow.up.to.line.circle.fill")
//      }
//      .tint(.blue)
//      Button {
//        showingCommentPopover = true
//      } label: {
//        Label("reply", systemImage: "arrowshape.turn.up.left.circle.fill")
//      }.tint(.orange)
//    }
//  }
//
//  var commentMetadata: some View {
//    CommentMetadataView(
//      comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted
//    )
//    .environmentObject(commentsFetcher)
//  }
//
//  var commentBody: some View {
//    Text(
//      try! AttributedString(styledMarkdown: comment.comment.content)
//    )
//  }
//
//  func commentCollapseAction() {
//    withAnimation(.linear(duration: 0.3)) {
//      if comment.isCollapsed {
//        commentsFetcher.updateCommentCollapseState(comment, isCollapsed: false)
//      } else {
//        for commentMainList in comments {
//          if commentMainList.comment.path.contains(comment.comment.path) {
//            if commentMainList.comment.path != comment.comment.path {
//              commentsFetcher.updateCommentCollapseState(commentMainList, isCollapsed: true)
//            } else {
//              commentsFetcher.updateCommentShrinkState(commentMainList, isShrunk: true)
//            }
//          }
//        }
//        collapseToIndex = listIndex
//        collapserPath = comment.comment.path
//      }
//    }
//  }
//}

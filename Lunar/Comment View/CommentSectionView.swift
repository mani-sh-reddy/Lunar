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
      ForEach(nestedComments, id: \.id) { comment in
        RecursiveComment(nestedComment: comment)
      }

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
      }
      .onTapGesture {
        isExpanded.toggle()
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        swipeActions
      }
      
      ForEach(nestedComment.subComments, id: \.id) { subComment in
        RecursiveComment(nestedComment: subComment)
          .padding(.leading, 10) // Add indentation
      }
    } else {
      ZStack{
        Text(try! AttributedString(markdown: "_Collapsed_"))
          .foregroundStyle(.gray)
          .font(.caption)
        Rectangle().foregroundStyle(.clear).ignoresSafeArea()
          .onTapGesture {
            isExpanded.toggle()
            haptics.impactOccurred(intensity: 0.5)
          }
      }
    }
  }
  var swipeActions: some View {
    return Group {
      Button {
        isExpanded.toggle()
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

//    DisclosureGroup(
//      isExpanded: $isExpanded,
//      content: {
//        ForEach(comment.subComments, id: \.id) { subComment in
//          if isExpanded {
//            RecursiveComment(comment: subComment)
//          } else {
//            EmptyView()
//          }
//        }
//      },
//      label: {
//        if isExpanded {
//          Text(try! AttributedString(markdown: comment.commentViewData.comment.content))
//            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//              Button {
//                isExpanded.toggle()
//              } label: {
//                Label("collapse", systemImage: "arrow.up.to.line.circle.fill")
//              }
//              .tint(.blue)
//              Button {
//                //        showCommentPopover = true
//              } label: {
//                Label("reply", systemImage: "arrowshape.turn.up.left.circle.fill")
//              }.tint(.orange)
//            }
//        } else {
//          Text(try! AttributedString(markdown: "_Collapsed_"))
//            .foregroundStyle(.gray)
//        }
//      }
//    )
//  }
//}

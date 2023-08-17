//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Kingfisher
import SwiftUI

struct CommentsView: View {
  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  var post: PostElement

  //  init(post: PostElement) {
  //    self.post = post
  //    _commentsFetcher = StateObject(
  //      wrappedValue: CommentsFetcher(postID: post.post.id)
  //    )
  //  }

  var body: some View {
    //    if commentsFetcher.isLoading { //TODO change back once done
    //      ProgressView()
    //    } else {
    CommentSectionView(
      post: post,
      comments: commentsFetcher.comments,
      postBody: post.post.body ?? "",
      upvoted: $upvoted,
      downvoted: $downvoted
    )
    //    }
  }
}

//struct CommentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentsView(post: MockData.postElement)
//      .previewLayout(PreviewLayout.sizeThatFits)
//  }
//}

struct CommentSectionView: View {
  var post: PostElement
  var comments: [CommentElement]
  var postBody: String

  @State var collapseToIndex: Int = 0
  @State var postBodyExpanded: Bool = false

  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

  //  init(
  //    post: PostElement,
  //    comments: [CommentElement],
  //    postBody: String
  ////    upvoted: Binding<Bool>,
  ////    downvoted: Binding<Bool>
  //  ) {
  //    self.post = post
  //    self.comments = comments
  //    self.postBody = postBody
  ////    self._upvoted = upvoted
  ////    self._downvoted = downvoted
  //  }

  var body: some View {
    List {
      Section {
        PostRowView(upvoted: $upvoted, downvoted: $downvoted, post: post)
        if !postBody.isEmpty {
          VStack(alignment: .trailing) {
            ExpandableTextBox(postBody).font(.body)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
      Section {
        ForEach(comments.indices, id: \.self) { index in
          var indentLevel: Int {
            let elements = comment.comment.path.split(separator: ".").map { String($0) }
            let elementCount = elements.isEmpty ? 1 : elements.count - 1
            if elementCount >= 1 {
              return elementCount
            } else {
              return 1
            }
          }

          let comment = comments[index]
          if index <= collapseToIndex && indentLevel != 1 {
            EmptyView()
          } else {
            CommentRowView(collapseToIndex: $collapseToIndex, comment: comment, listIndex: index)
          }
        }
      }
    }.listStyle(.grouped)
  }
}

//struct CommentRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentRowView(collapseToIndex: .constant(0), comment: MockData.commentElement, listIndex: 0)
//      .previewLayout(PreviewLayout.sizeThatFits)
//  }
//}

struct CommentRowView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @Binding var collapseToIndex: Int
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false

  let comment: CommentElement
  let listIndex: Int

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
      ForEach(1..<indentLevel, id: \.self) { _ in
        Rectangle().opacity(0).frame(width: 0.5).padding(.horizontal, 0)
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
        Text(comment.creator.name.uppercased())
          .font(.caption)
          .bold()
          .foregroundStyle(.secondary)
        Text(comment.comment.content)
        HStack {
          ReactionButton(
            text: String(comment.counts.upvotes),
            icon: "arrow.up.circle.fill",
            color: Color.green,
            active: $commentUpvoted,
            opposite: $commentDownvoted
          )
          .onTapGesture {
            commentUpvoted.toggle()
            commentDownvoted = false
          }
          ReactionButton(
            text: String(comment.counts.downvotes),
            icon: "arrow.down.circle.fill",
            color: Color.red,
            active: $commentUpvoted,
            opposite: $commentDownvoted
          )
          .onTapGesture {
            commentDownvoted.toggle()
            commentUpvoted = false
          }
        }
      }
    }
    .onTapGesture {
      withAnimation(.smooth) {
        self.collapseToIndex = listIndex
      }
    }
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      if indentLevel != 1 {
        CollapseCommentsSwipeAction(collapseToIndex: $collapseToIndex, listIndex: listIndex)
      }
    }
  }
}

struct CollapseCommentsSwipeAction: View {
  //  @Binding var isClicked: Bool
  @Binding var collapseToIndex: Int
  var listIndex: Int

  var body: some View {
    Button {
      print("SWIPED")
      withAnimation(.smooth) {
        self.collapseToIndex = listIndex
      }
    } label: {
      Image(systemName: "arrow.up.to.line.circle.fill")
    }
    .tint(.blue)
  }
}

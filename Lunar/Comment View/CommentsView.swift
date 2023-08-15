//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Kingfisher
import SwiftUI

struct CommentsView: View {
  @StateObject private var commentsFetcher: CommentsFetcher
  var post: PostElement

  init(post: PostElement) {
    self.post = post
    _commentsFetcher = StateObject(
      wrappedValue: CommentsFetcher(postID: post.post.id)
    )
  }

  var body: some View {
    if commentsFetcher.isLoading {
      ProgressView()
    } else {
      CommentSectionView(
        post: post,
        comments: commentsFetcher.comments,
        postBody: post.post.body ?? ""
      )
    }
  }
}

struct CommentSectionView: View {
  var post: PostElement
  var comments: [CommentElement]
  var postBody: String
  @State private var collapseToIndex: Int = 0

  init(
    post: PostElement,
    comments: [CommentElement],
    postBody: String
  ) {
    self.post = post
    self.comments = comments
    self.postBody = postBody
  }

  var body: some View {
    List {
      Section {
        PostRowView(post: post)
        if !postBody.isEmpty {
          Text(postBody)
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

struct CommentRowView: View {
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @Binding var collapseToIndex: Int
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
      Text(comment.comment.content)
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

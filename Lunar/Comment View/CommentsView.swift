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
        ForEach(comments, id: \.comment.id) { comment in
          CommentRowView(comment: comment)
        }
      }
    }.listStyle(.insetGrouped)
  }
}

struct CommentRowView: View {
  let comment: CommentElement
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
  }
}

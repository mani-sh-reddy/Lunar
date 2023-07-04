//
//  LegacyKbinCommentsView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import SwiftUI

struct LegacyKbinCommentsView: View {
  @StateObject private var kbinCommentsFetcher: LegacyKbinCommentsFetcher
  @StateObject private var kbinThreadBodyFetcher: LegacyKbinThreadBodyFetcher

  var post: LegacyKbinPost

  init(post: LegacyKbinPost, postURL: String) {
    _kbinCommentsFetcher = StateObject(
      wrappedValue: LegacyKbinCommentsFetcher(postURL: postURL)
    )
    _kbinThreadBodyFetcher = StateObject(
      wrappedValue: LegacyKbinThreadBodyFetcher(postURL: postURL)
    )
    self.post = post
  }

  var body: some View {
    if kbinCommentsFetcher.isLoading {
      ProgressView()
    } else {
      LegacyKbinCommentSectionView(
        post: post,
        postBody: kbinThreadBodyFetcher.postBody,
        comments: kbinCommentsFetcher.comments
      )
    }
  }
}

struct LegacyKbinCommentSectionView: View {
  var post: LegacyKbinPost
  var postBody: String
  var comments: [LegacyKbinComment]

  init(
    post: LegacyKbinPost,
    postBody: String,
    comments: [LegacyKbinComment]
  ) {
    self.post = post
    self.comments = comments
    self.postBody = postBody
  }

  var body: some View {
    List {
      Section {
        LegacyKbinPostRowView(post: post)
        if !postBody.isEmpty {
          Text(postBody)
        }
      }
      Section {
        ForEach(comments, id: \.id) { comment in
          LegacyKbinCommentRowView(comment: comment)
        }
      }
    }.listStyle(.grouped)
  }
}

struct LegacyKbinCommentRowView: View {
  let comment: LegacyKbinComment
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
      ForEach(1 ..< (Int(comment.indentLevel) ?? 1), id: \.self) { _ in
        Rectangle().opacity(0).frame(width: 0.5).padding(.horizontal, 0)
      }
      let indentLevel = min(Int(comment.indentLevel) ?? 0, commentHierarchyColors.count - 1)
      let foregroundColor = commentHierarchyColors[indentLevel]
      if (Int(comment.indentLevel) ?? 1) > 1 {
        Capsule(style: .continuous)
          .foregroundStyle(foregroundColor)
          .frame(width: 1)
          .padding(.vertical, 0)
          .padding(.horizontal, 0)
      }
      Text(comment.content)
    }
  }
}

// struct KbinCommentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    /// need to set showing popover to a constant value
//    KbinCommentsView(post: MockData.kbinPost, postURL: MockData.kbinPostURL)
//  }
// }

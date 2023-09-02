//
//  KbinCommentsView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import SwiftUI

struct KbinCommentsView: View {
  @StateObject private var kbinCommentsFetcher: KbinCommentsFetcher
  @StateObject private var kbinThreadBodyFetcher: KbinThreadBodyFetcher

  var post: KbinPost

  init(post: KbinPost, postURL: String) {
    _kbinCommentsFetcher = StateObject(
      wrappedValue: KbinCommentsFetcher(postURL: postURL)
    )
    _kbinThreadBodyFetcher = StateObject(
      wrappedValue: KbinThreadBodyFetcher(postURL: postURL)
    )
    self.post = post
  }

  var body: some View {
    if kbinCommentsFetcher.isLoading {
      ProgressView()
    } else {
      KbinCommentSectionView(
        post: post,
        postBody: kbinThreadBodyFetcher.postBody,
        comments: kbinCommentsFetcher.comments
      )
    }
  }
}

struct KbinCommentSectionView: View {
  var post: KbinPost
  var postBody: String
  var comments: [KbinComment]

  init(
    post: KbinPost,
    postBody: String,
    comments: [KbinComment]
  ) {
    self.post = post
    self.comments = comments
    self.postBody = postBody
  }

  var body: some View {
    List {
      Section {
        KbinPostRowView(post: post)
        if !postBody.isEmpty {
          Text(postBody)
        }
      }
      Section {
        ForEach(comments, id: \.id) { comment in
          KbinCommentRowView(comment: comment)
        }
      }
    }.listStyle(.grouped)
  }
}

struct KbinCommentRowView: View {
  let comment: KbinComment
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

//
//  KbinCommentsView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Kingfisher
import SwiftUI

struct KbinCommentsView: View {
  @StateObject private var kbinCommentsFetcher: KbinCommentsFetcher
  //    @StateObject var kbinThreadBodyFetcher: KbinThreadBodyFetcher

  init(postURL: String) {
    _kbinCommentsFetcher = StateObject(wrappedValue: KbinCommentsFetcher(postURL: postURL))
  }

  var body: some View {
    if kbinCommentsFetcher.isLoading {
      ProgressView()
    } else {
      KbinCommentSectionView(comments: kbinCommentsFetcher.comments)
    }
  }

  struct KbinCommentSectionView: View {
    var comments: [KbinComment]
    var body: some View {
      List {
        ForEach(comments, id: \.id) { comment in
          KbinCommentRowView(comment: comment)
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
        ForEach(1..<(Int(comment.indentLevel) ?? 1), id: \.self) { _ in
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
    //            if !comment.replies.isEmpty {
    //                KbinCommentRowView(comments: comment.replies)
    //            }
  }
}

struct KbinCommentsView_Previews: PreviewProvider {
  static var previews: some View {
    /// need to set showing popover to a constant value
    KbinCommentsView(postURL: MockData.kbinPostURL)
  }
}

//        List {
//            Section {
//                    KbinCommentRowView(comments: kbinCommentsFetcher.comments)
//            } header: {
//                VStack(spacing: 10) {
//                    Text(post.title).bold().font(.title)
//                        .foregroundStyle(.foreground)
//                    InPostThumbnailView(thumbnailURL: post.imageUrl)
//                    Text(kbinThreadBodyFetcher.postBody)
//                        .foregroundStyle(.foreground)
//                        .font(.body)
//                }.padding(.vertical, 10)
//
//            }.textCase(.none)
//
//        }.listStyle(.grouped)
//    }

//            if !comment.replies.isEmpty {
//                KbinCommentRowView(comments: comment.replies)
//            }

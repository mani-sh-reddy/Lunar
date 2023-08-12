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
    let elementCount = elements.isEmpty ? 1 : elements.count
    return elementCount - 1
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
          .padding(.vertical, 0)
          .padding(.horizontal, 0)
      }
      Text(comment.comment.content)
    }
  }
}

//struct CommentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    /// need to set showing popover to a constant value
//    CommentsView(post: MockData., postURL: MockData.kbinPostURL)
//  }
//}


//struct CommentsView: View {
//  @StateObject var commentsFetcher: CommentsFetcher
//  @State var postID: Int
//  var postTitle: String
//  var thumbnailURL: String?
//  var postBody: String?
//
//  var body: some View {
//    ScrollViewReader { _ in
//      VStack {
//        List {
//          Text(postTitle).font(.title).bold()
//            .listRowSeparator(.hidden)
//
//          if let thumbnailURL {
//            InPostThumbnailView(thumbnailURL: thumbnailURL)
//              .listRowSeparator(.hidden)
//          }
//
//          if let postBody {
//            ZStack {
//              RoundedRectangle(cornerRadius: 10, style: .continuous)
//                .foregroundStyle(.regularMaterial)
//              Text(postBody)
//                .padding(10)
//                .multilineTextAlignment(.leading)
//            }
//            .padding(.bottom, 20)
//          }
//
//          ForEach(commentsFetcher.comments, id: \.comment.id) { comment in
//            HStack(spacing: 5) {
//              CommentIndentGuideView(commentPath: comment.comment.path)
//              VStack(alignment: .leading) {
//                Text(String(comment.creator.name.uppercased()))
//                  .fontWeight(.bold)
//                  .foregroundStyle(.gray)
//                  .font(.footnote)
//                  .padding(.vertical, 2)
//                Text(String(comment.comment.content))
//              }
//              .padding(.leading, 10)
//            }
//            .padding(.vertical, 5)
//            .task {
//              commentsFetcher.loadMoreContentIfNeeded(currentItem: comment)
//            }
//            .accentColor(Color.primary)
//          }
//          if commentsFetcher.isLoading {
//            ProgressView()
//          }
//        }
//        .refreshable {
//          await commentsFetcher.refreshContent()
//        }
//        .listStyle(.plain)
//      }
//      .navigationBarTitleDisplayMode(.inline)
//      .toolbar {
//        ToolbarItem(placement: .navigationBarTrailing) {
//          Image(systemName: "chart.line.uptrend.xyaxis")
//        }
//      }
//    }
//  }
//}
//
//struct CommentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    let commentsFetcher = CommentsFetcher(
//      postID: 1_442_451,
//      sortParameter: "Top",
//      typeParameter: "All"
//    )
//
//    CommentsView(
//      commentsFetcher: commentsFetcher,
//      postID: 1_442_451,
//      postTitle: MockData.commentsViewPostTitle1,
//      thumbnailURL: MockData.commentsViewThumbnailURL1,
//      postBody: MockData.commentsViewPostBody1
//    )
//  }
//}

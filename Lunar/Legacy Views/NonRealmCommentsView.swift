//
//  NonRealmCommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Defaults
import MarkdownUI
import SFSafeSymbols
import SwiftUI

struct NonRealmCommentsView: View {
  @Default(.activeAccount) var activeAccount

  @StateObject var commentsFetcher: CommentsFetcher
  @State var postBodyExpanded = false

  var post: PostObject

  var body: some View {
    List {
      postSection
      commentsSection
    }
    .listStyle(.grouped)
    .navigationTitle(post.post.name)
    .environmentObject(commentsFetcher)
  }

  var commentsSection: some View {
    Section {
      if commentsFetcher.isLoading {
        ProgressView()
      } else {
        let nestedComments = commentsFetcher.comments.nestedComment
        ForEach(nestedComments, id: \.id) { comment in
          NonRealmRecursiveComment(
            nestedComment: comment,
            post: post
          )
        }
      }
    }
  }

  var postSection: some View {
    Section {
      NonRealmPostItem(post: post)
        .padding(.horizontal, -5)
      if let postBody = post.post.body, !postBody.isEmpty {
        DisclosureGroup(isExpanded: $postBodyExpanded) {
          Markdown { postBody }
        } label: {
          if postBodyExpanded {
            Text("")
          } else {
            Text(postBody)
              .italic()
              .foregroundStyle(.gray)
              .lineLimit(3)
              .font(.caption)
          }
        }
      }
    }
  }
}

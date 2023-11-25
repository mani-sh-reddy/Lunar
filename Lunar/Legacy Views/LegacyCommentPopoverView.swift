//
//  LegacyCommentPopoverView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SwiftUI

struct LegacyCommentPopoverView: View {
  @Binding var showingCommentPopover: Bool
  @State private var commentString: String = ""
  @State private var commentStringUnsent: String = ""
  @EnvironmentObject var commentsFetcher: CommentsFetcher

  var post: Post
  var comment: Comment?

  var body: some View {
    List {
      // MARK: - Post Title

      Section {
        if let comment {
          Text(comment.content)
        } else {
          Text(post.name)
        }
      } header: {
        Text("Replying to:")
          .textCase(.none)
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      // MARK: - Text Field

      Section {
        TextEditor(text: $commentStringUnsent)
          .background(Color.clear)
          .font(.body)
          .frame(height: 150)
      } header: {
        Text("Type here to comment...")
          .textCase(.none)
      }

      // MARK: - Submit Button

      Section {
        Button {
          commentString = commentStringUnsent
          if !commentString.isEmpty {
            CommentSender(
              content: commentString,
              postID: post.id,
              parentID: comment?.id
            ).fetchCommentResponse { response in
              if response == "success" {
                showingCommentPopover = false
                commentsFetcher.loadContent(isRefreshing: true)
              } else {
                print("ERROR SENDING COMMENT")
              }
            }
          }
          print(commentString)
        } label: {
          HStack {
            Spacer()
            Text("Submit")
            Spacer()
          }
        }
      }
      DismissButtonView(dismisser: $showingCommentPopover)
    }
    .listStyle(.insetGrouped)
  }
}

// struct CommentPopoverView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentPopoverView(showingCommentPopover: .constant(false), post: MockData.postElement.post)
//  }
// }

//
//  CommentPopoverView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SwiftUI

struct CommentPopoverView: View {
  @Binding var showCommentPopover: Bool
  @State private var commentString: String = ""
  @State private var commentStringUnsent: String = ""

  var post: Post
  var parentID: Int?

  var body: some View {
    List {

      // MARK: - Post Title
      Section {
        Text(post.name)
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
              parentID: parentID
            ).fetchCommentResponse { response in
              if response == "success" {
                showCommentPopover = false
              } else {
                print("ERROR SENDING COMMENT")
              }
            }
          }
          print(commentString)
        } label: {
          HStack {
            Spacer()
            Text("Post")
            Spacer()
          }
        }
      }

    }
    .listStyle(.insetGrouped)
  }
}

//struct CommentPopoverView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentPopoverView(showCommentPopover: .constant(false), post: MockData.postElement.post)
//  }
//}

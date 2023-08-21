//
//  InPostActionsView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SwiftUI

struct InPostActionsView: View {
  @State var showCommentPopover: Bool = false
  @State var commentString: String = ""
  
  var post: PostElement
  
  var body: some View {
    ReactionButton(text: "Comment", icon: "bubble.left.circle.fill", color: .blue, active: .constant(false), opposite: .constant(false))
      .highPriorityGesture(
        TapGesture().onEnded {
          showCommentPopover = true
        }
      )
      .sheet(isPresented: $showCommentPopover){
        CommentPopoverView(showCommentPopover: $showCommentPopover, commentString: $commentString, post: post)
      }
  }
}


struct CommentPopoverView: View {
  @Binding var showCommentPopover: Bool
  @Binding var commentString: String
  @State private var commentStringUnsent: String = ""
  
  var post: PostElement
  
  var body: some View {
    List {
      
      // MARK: - Post Title
      Section {
        Text(post.post.name)
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
          .frame(height: 200)
      } header: {
        Text("Type here to comment...")
          .textCase(.none)
      }
      
      // MARK: - Submit Button
      Section{
        Button{
          commentString = commentStringUnsent
          showCommentPopover = false
          print(commentString)
        } label: {
          HStack{
            Spacer()
            Text("Post")
            Spacer()
          }
        }
      }
      
    }
    .padding(10)
    .listStyle(.insetGrouped)
  }
}


struct CommentPopoverView_Previews: PreviewProvider {
  static var previews: some View {
    CommentPopoverView(showCommentPopover: .constant(false), commentString: .constant("This is an example comment string"), post: MockData.postElement)
  }
}

struct InPostActionsView_Previews: PreviewProvider {
  static var previews: some View {
    InPostActionsView(post: MockData.postElement)
  }
}

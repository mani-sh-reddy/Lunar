//
//  InPostActionsView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SwiftUI

struct InPostActionsView: View {
  @State var showCommentPopover: Bool = false

  var post: PostObject

  var body: some View {
    ReactionButton(
      text: "Comment", icon: "bubble.left.circle.fill", color: .blue, active: .constant(false),
      opposite: .constant(false)
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        showCommentPopover = true
      }
    )
    .sheet(isPresented: $showCommentPopover) {
      CommentPopoverView(showCommentPopover: $showCommentPopover, post: post.post)
    }
  }
}

// struct InPostActionsView_Previews: PreviewProvider {
//  static var previews: some View {
//    InPostActionsView(post: MockData.postElement.post)
//  }
// }

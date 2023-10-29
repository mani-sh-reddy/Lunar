//
//  LegacyInPostActionsView.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import SFSafeSymbols
import SwiftUI

struct LegacyInPostActionsView: View {
  @State var showingCommentPopover: Bool = false

  var post: PostObject

  var body: some View {
    ReactionButton(
      text: "Comment", icon: SFSafeSymbols.SFSymbol.bubbleLeftCircleFill, color: .blue,
      active: .constant(false),
      opposite: .constant(false)
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        showingCommentPopover = true
      }
    )
    .sheet(isPresented: $showingCommentPopover) {
      LegacyCommentPopoverView(showingCommentPopover: $showingCommentPopover, post: post.post)
    }
  }
}

// struct InPostActionsView_Previews: PreviewProvider {
//  static var previews: some View {
//    InPostActionsView(post: MockData.postElement.post)
//  }
// }

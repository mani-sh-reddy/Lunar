//
//  CommentSectionView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SFSafeSymbols
import SwiftUI

struct CommentSectionView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher

  var post: RealmPost
  var comments: [CommentObject]
  var postBody: String

  @State var collapseToIndex: Int = 0
  @State var collapserPath: String = ""

  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

  var communityIsSubscribed: Bool {
    false
  }

  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    recursiveCommentSection
  }

  @ViewBuilder
  var recursiveCommentSection: some View {
    let nestedComments = comments.nestedComment
    ForEach(nestedComments, id: \.id) { comment in
      RecursiveComment(
        nestedComment: comment,
        post: post
      )
    }
  }
}

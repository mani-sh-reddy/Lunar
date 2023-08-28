//
//  CommentMetadataView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SwiftUI

struct CommentMetadataView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  var comment: CommentElement
  let dateTimeParser = DateTimeParser()
  @Binding var commentUpvoted: Bool
  @Binding var commentDownvoted: Bool
  
  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text(comment.creator.name.uppercased())
          .bold()
        Text(dateTimeParser.timeAgoString(from: comment.comment.published))
      }
      .padding(.top, 2)
      .font(.caption)
      .foregroundStyle(.secondary)
      Spacer()
      ReactionButton(
        text: String(commentUpvoted ? comment.counts.upvotes + 1 : comment.counts.upvotes),
        icon: "arrow.up.circle.fill",
        color: Color.green,
        active: $commentUpvoted,
        opposite: $commentDownvoted
      )
      .highPriorityGesture(
        TapGesture().onEnded {
          haptics.impactOccurred()
          commentUpvoted.toggle()
          commentDownvoted = false
          if commentUpvoted {
            sendReaction(voteType: 1)
          } else {
            sendReaction(voteType: 0)
          }
        }
      )
      ReactionButton(
        text: String(commentDownvoted ? comment.counts.downvotes + 1 : comment.counts.downvotes),
        icon: "arrow.down.circle.fill",
        color: Color.red,
        active: $commentDownvoted,
        opposite: $commentUpvoted
      )
      .highPriorityGesture(
        TapGesture().onEnded {
          haptics.impactOccurred()
          commentDownvoted.toggle()
          commentUpvoted = false
          if commentDownvoted {
            sendReaction(voteType: -1)
          } else {
            sendReaction(voteType: 0 )
          }
        }
      )
    }
    .onAppear {
      if let voteType = comment.myVote {
        switch voteType {
        case 1:
          self.commentUpvoted = true
          self.commentDownvoted = false
        case -1:
          self.commentUpvoted = false
          self.commentDownvoted = true
        default:
          self.commentUpvoted = false
          self.commentDownvoted = false
        }
      }
    }
  }
  
  func sendReaction(voteType: Int) {
    VoteSender(
      asActorID: selectedActorID,
      voteType: voteType,
      postID: 0, communityActorID: "",
      commentID: comment.comment.id,
      elementType: "comment"
    ).fetchVoteInfo { commentID, voteSubmittedSuccessfully, _ in
      if voteSubmittedSuccessfully {
        if let index = commentsFetcher.comments.firstIndex(where: { $0.comment.id == commentID }) {
          var updatedComment = commentsFetcher.comments[index]
          updatedComment.myVote = voteType
          commentsFetcher.comments[index] = updatedComment
        }
      }
    }
  }
  
}

//
//  CommentMetadataView.swift
//  Lunar
//
//  Created by Mani on 18/08/2023.
//

import SFSafeSymbols
import SwiftUI

struct CommentMetadataView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  var comment: CommentObject
  let dateTimeParser = DateTimeParser()
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false

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
      upvoteButton
      downvoteButton
    }

    .onAppear {
      if let voteType = comment.myVote {
        switch voteType {
        case 1:
          commentUpvoted = true
          commentDownvoted = false
        case -1:
          commentUpvoted = false
          commentDownvoted = true
        default:
          commentUpvoted = false
          commentDownvoted = false
        }
      }
    }
  }

  var upvoteButton: some View {
    ReactionButton(
      text: String(
        (commentUpvoted ? (comment.counts.upvotes ?? 0) + 1 : comment.counts.upvotes) ?? 0
      ),
      icon: SFSafeSymbols.SFSymbol.arrowUpCircleFill,
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
  }

  var downvoteButton: some View {
    ReactionButton(
      text: String((commentDownvoted ? (comment.counts.downvotes ?? 0) + 1 : comment.counts.downvotes) ?? 0),
      icon: SFSafeSymbols.SFSymbol.arrowDownCircleFill,
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
          sendReaction(voteType: 0)
        }
      }
    )
  }

  func sendReaction(voteType: Int) {
    VoteSender(
      asActorID: selectedActorID,
      voteType: voteType,
      postID: 0,
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

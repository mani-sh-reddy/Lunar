//
//  CommentsView.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import Kingfisher
import SwiftUI

struct CommentsView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  @StateObject var commentsFetcher: CommentsFetcher
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  var post: PostElement

//  init(post: PostElement) {
//    self.post = post
//    _commentsFetcher = StateObject(
//      wrappedValue: CommentsFetcher(postID: post.post.id)
//    )
//  }

  var body: some View {
//    if commentsFetcher.isLoading { //TODO change back once done
//      ProgressView()
//    } else {
      CommentSectionView(
        post: post,
        comments: commentsFetcher.comments,
        postBody: post.post.body ?? "",
        upvoted: $upvoted,
        downvoted: $downvoted
      ).environmentObject(postsFetcher).environmentObject(commentsFetcher)
//    }
  }
}

//struct CommentsView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentsView(post: MockData.postElement)
//      .previewLayout(PreviewLayout.sizeThatFits)
//  }
//}

struct CommentSectionView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  var post: PostElement
  var comments: [CommentElement]
  var postBody: String
  
  @State var collapseToIndex: Int = 0
  @State var postBodyExpanded:Bool = false
  
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

//  init(
//    post: PostElement,
//    comments: [CommentElement],
//    postBody: String
////    upvoted: Binding<Bool>,
////    downvoted: Binding<Bool>
//  ) {
//    self.post = post
//    self.comments = comments
//    self.postBody = postBody
////    self._upvoted = upvoted
////    self._downvoted = downvoted
//  }

  var body: some View {
    List {
      Section {
        PostRowView(upvoted: $upvoted, downvoted: $downvoted, post: post).environmentObject(postsFetcher)
        if !postBody.isEmpty {
          VStack (alignment: .trailing){
            ExpandableTextBox(postBody).font(.body)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)
      Section {
        ForEach(comments.indices, id: \.self) { index in
          var indentLevel: Int {
            let elements = comment.comment.path.split(separator: ".").map { String($0) }
            let elementCount = elements.isEmpty ? 1 : elements.count - 1
            if elementCount >= 1 {
              return elementCount
            } else {
              return 1
            }
          }
          
          let comment = comments[index]
          if index <= collapseToIndex && indentLevel != 1 {
            EmptyView()
          } else {
            CommentRowView(collapseToIndex: $collapseToIndex, comment: comment, listIndex: index)
              .environmentObject(commentsFetcher)
          }
        }
      }
    }.listStyle(.grouped)
  }
}

//struct CommentRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    CommentRowView(collapseToIndex: .constant(0), comment: MockData.commentElement, listIndex: 0)
//      .previewLayout(PreviewLayout.sizeThatFits)
//  }
//}

struct CommentRowView: View {
  @EnvironmentObject var commentsFetcher: CommentsFetcher
  @AppStorage("commentMetadataPosition") var commentMetadataPosition = Settings.commentMetadataPosition
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @Binding var collapseToIndex: Int
  @State var commentUpvoted: Bool = false
  @State var commentDownvoted: Bool = false
  
  let comment: CommentElement
  let listIndex: Int
  
  var indentLevel: Int {
    let elements = comment.comment.path.split(separator: ".").map { String($0) }
    let elementCount = elements.isEmpty ? 1 : elements.count - 1
    if elementCount >= 1 {
      return elementCount
    } else {
      return 1
    }

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
        if debugModeEnabled {
          Text(String(listIndex))
        }
        ForEach(1..<indentLevel, id: \.self) { _ in
          Rectangle().opacity(0).frame(width: 0.1).padding(.horizontal, 0)
        }
        let indentLevel = min(indentLevel, commentHierarchyColors.count - 1)
        let foregroundColor = commentHierarchyColors[indentLevel]
        if indentLevel > 1 {
          Capsule(style: .continuous)
            .foregroundStyle(foregroundColor)
            .frame(width: 1)
            .padding(0)
        }
        VStack(alignment: .leading, spacing: 3) {
          if commentMetadataPosition == "Bottom" {
            Text(comment.comment.content)
            CommentMetadata(comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted)
              .environmentObject(commentsFetcher)
          } else if commentMetadataPosition == "Top" {
            CommentMetadata(comment: comment, commentUpvoted: $commentUpvoted, commentDownvoted: $commentDownvoted)
              .environmentObject(commentsFetcher)
            Text(comment.comment.content)
          } else {
            Text(comment.comment.content)
          }
        }
      }
      .onTapGesture {
        withAnimation(.smooth) {
          self.collapseToIndex = listIndex
        }
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        if indentLevel != 1 {
          CollapseCommentsSwipeAction(collapseToIndex: $collapseToIndex, listIndex: listIndex)
        }
      }
  }
}

struct CollapseCommentsSwipeAction: View {
  //  @Binding var isClicked: Bool
  @Binding var collapseToIndex: Int
  var listIndex: Int
  
  var body: some View {
    Button {
      print("SWIPED")
      withAnimation(.smooth) {
        self.collapseToIndex = listIndex
      }
    } label: {
      Image(systemName: "arrow.up.to.line.circle.fill")
    }
    .tint(.blue)
  }
}

struct CommentMetadata: View {
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

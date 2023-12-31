//
//  CompactPostItem.swift
//  Lunar
//
//  Created by Mani on 24/10/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct CompactPostItem: View {
  //  var post: RealmPost
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.activeAccount) var activeAccount

  @ObservedRealmObject var post: RealmPost

  @State var showSafari: Bool = false

  var navigable: Bool?
  let hapticsLight = UIImpactFeedbackGenerator(style: .light)
  var parentView: String? = "PostsView"

  var image: String? {
    let thumbnail = post.postThumbnailURL ?? ""
    let url = post.postURL ?? ""
    let urlIsValidImage = url.isValidExternalImageURL()
    if !thumbnail.isEmpty {
      return thumbnail
    } else if !url.isEmpty, urlIsValidImage {
      return url
    } else {
      return nil
    }
  }

  var communityLabel: String {
    let name = post.communityName
    let actorID = post.communityActorID
    let instance = URLParser.extractDomain(from: actorID)
    if !actorID.isEmpty {
      return "\(name)@\(instance)"
    } else {
      return name
    }
  }

  var creatorTimeAgoLabel: String {
    let creator = post.personName.uppercased()
    let timeAgo = post.postTimeAgo
    if !timeAgo.isEmpty {
      return "\(creator), \(timeAgo) ago"
    } else {
      return "\(creator)"
    }
  }

  var webLink: String {
    let url = post.postURL ?? ""
    return URLParser.extractBaseDomain(from: url)
  }

  var body: some View {
    ZStack {
      postBackground
      if post.postMinimised, parentView == "PostsView" {
        if post.postFeatured {
          postMinimisedFeatured
        } else {
          postMinimised
        }
      } else {
        VStack(alignment: .leading, spacing: 7) {
          HStack {
            postImage
              .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 7) {
              postCreatorLabel
              postCommunityLabel
              HStack(spacing: 5) {
                postUpvotes
                postDownvotes
                Spacer()
                postWebLink
              }
            }
          }
          postTitle
          if debugModeEnabled {
            debugValues
          }
        }
        .padding(navigable ?? false ? 10 : 0)
      }
      if navigable != nil, navigable == true {
        commentsNavLink
      }
    }
    .listRowSeparator(.hidden)
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      minimiseButton.labelsHidden()
      hideButton.labelsHidden()
    }
    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      upvoteButton.labelsHidden()
      downvoteButton.labelsHidden()
    }
    .contextMenu {
      upvoteButton
      hideButton
      minimiseButton
    }
  }

  var hideButton: some View {
    Button {
      RealmThawFunctions().hideAction(post: post)
    } label: {
      Label("Hide", systemSymbol: AllSymbols().hideContextIcon)
    }
    .tint(.orange)
  }

  var minimiseButton: some View {
    Button {
      RealmThawFunctions().minimiseToggleAction(post: post)
    } label: {
      Label("Minimise", systemSymbol: AllSymbols().minimiseContextIcon)
    }
    .tint(.yellow)
  }

  var upvoteButton: some View {
    Button {
      RealmThawFunctions().upvoteAction(post: post)
    } label: {
      Label("Upvote", systemSymbol: AllSymbols().upvoteContextIcon)
    }
    .tint(.green)
  }

  var downvoteButton: some View {
    Button {
      RealmThawFunctions().downvoteAction(post: post)
    } label: {
      Label("Downvote", systemSymbol: AllSymbols().downvoteContextIcon)
    }
    .tint(.red)
  }

  var postBackground: some View {
    RoundedRectangle(cornerRadius: 13, style: .continuous)
      .foregroundStyle(Color.postBackground)
  }

  @ViewBuilder
  var postImage: some View {
    if let image {
      InPostThumbnailView(thumbnailURL: image)
        .padding(.vertical, 5)
    }
  }

  var postCommunityLabel: some View {
    Text(communityLabel)
      .textCase(.lowercase)
      .foregroundColor(.secondary)
      .font(.caption)
      .highPriorityGesture(
        TapGesture().onEnded {
          hapticsLight.impactOccurred(intensity: 0.5)
        }
      )
  }

  var postTitle: some View {
    Text(post.postName)
      .fontWeight(.semibold)
      .foregroundColor(.primary)
  }

  var postMinimised: some View {
    HStack {
      Text(post.postName)
        .italic()
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(.secondary)
        .lineLimit(1)
        .padding(.horizontal)
        .padding(.vertical, 5)
      Spacer()
    }
  }

  var postMinimisedFeatured: some View {
    HStack {
      Text(post.postName)
        .font(.caption)
        .fontWeight(.semibold)
        .lineLimit(1)
        .padding(.horizontal)
        .padding(.vertical, 5)
      Spacer()
      Image(systemSymbol: .pinCircleFill)
        .symbolRenderingMode(.multicolor)
        .padding(.horizontal, 5)
    }
  }

  var postCreatorLabel: some View {
    Text(creatorTimeAgoLabel)
      .font(.caption)
      .foregroundColor(.secondary)
  }

  var postUpvotes: some View {
    PostButtonItem(
      text: String(post.upvotes ?? 0),
      icon: .arrowUpCircleFill,
      color: Color.green,
      active: post.postMyVote == 1,
      opposite: false
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        RealmThawFunctions().upvoteAction(post: post)
        sendReaction(voteType: 1, postID: post.postID)
      })
  }

  @ViewBuilder
  var postDownvotes: some View {
    if let downvotes = post.downvotes {
      PostButtonItem(
        text: String(downvotes),
        icon: .arrowDownCircleFill,
        color: Color.red,
        active: post.postMyVote == -1,
        opposite: false
      )
      .highPriorityGesture(
        TapGesture().onEnded {
          RealmThawFunctions().downvoteAction(post: post)
          sendReaction(voteType: -1, postID: post.postID)
        })
    }
  }

//  var postComments: some View {
//    PostButtonItem(
//      text: String(post.postCommentCount ?? 0),
//      icon: .bubbleLeftCircleFill,
//      color: Color.gray
//    )
//  }

  @ViewBuilder
  var postWebLink: some View {
    if let url = post.postURL {
      if post.postURL != post.postThumbnailURL {
        PostButtonItem(
          text: webLink,
          icon: .safari,
          color: Color.blue
        )
        .highPriorityGesture(
          TapGesture().onEnded {
            showSafari.toggle()
          }
        )
        .inAppSafari(isPresented: $showSafari, stringURL: url)
      }
    }
  }

  var commentsNavLink: some View {
    NavigationLink {
      CommentsView(
        commentsFetcher: CommentsFetcher(postID: post.postID),
        upvoted: .constant(false),
        downvoted: .constant(false),
        post: post
      )
    } label: {
      EmptyView()
    }
    .opacity(0)
  }

  func sendReaction(voteType: Int, postID: Int) {
    VoteSender(
      asActorID: activeAccount.actorID,
      voteType: voteType,
      postID: postID,
      commentID: 0,
      elementType: "post"
    ).fetchVoteInfo { postID, voteSubmittedSuccessfully, _ in
      print("RETURNED /post/like \(String(describing: postID)):\(voteSubmittedSuccessfully)")
    }
  }

  var debugValues: some View {
    VStack(alignment: .leading) {
      DebugTextView(name: "communityID", value: String(describing: post.communityID))
      DebugTextView(name: "communityActorID", value: post.communityActorID)
      DebugTextView(name: "sort", value: post.sort)
      DebugTextView(name: "type", value: post.type)
    }
  }
}

#Preview {
  CompactPostItem(post: MockData().post, parentView: "PostsView")
    .previewLayout(.sizeThatFits)
}

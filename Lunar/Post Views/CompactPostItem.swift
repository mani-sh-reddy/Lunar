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

  let hapticsSoft = UIImpactFeedbackGenerator(style: .soft)
  let hapticsLight = UIImpactFeedbackGenerator(style: .light)
  let notificationHaptics = UINotificationFeedbackGenerator()

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

  var creatorLabel: String {
    let dateTimeParser = DateTimeParser()
    let published = post.postPublished
    let creator = post.personName.uppercased()
    let timeAgo = ", \(dateTimeParser.timeAgoString(from: published))"
    return "\(creator)\(timeAgo)"
  }

  var webLink: String {
    let url = post.postURL ?? ""
    return URLParser.extractBaseDomain(from: url)
  }

  var body: some View {
    ZStack {
      postBackground
      if post.postMinimised {
        postMinimised
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
      Label("Hide", systemSymbol: .eyeSlash)
    }
    .tint(.orange)
  }

  var minimiseButton: some View {
    Button {
      RealmThawFunctions().minimiseToggleAction(post: post)
    } label: {
      Label("Minimise", systemSymbol: .rectangleArrowtriangle2Inward)
    }
    .tint(.yellow)
  }

  var upvoteButton: some View {
    Button {
      RealmThawFunctions().upvoteAction(post: post)
    } label: {
      Label("Upvote", systemSymbol: .arrowUpCircleFill)
    }
    .tint(.green)
  }

  var downvoteButton: some View {
    Button {
      RealmThawFunctions().downvoteAction(post: post)
    } label: {
      Label("Downvote", systemSymbol: .arrowDownCircleFill)
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

  var postCreatorLabel: some View {
    Text(creatorLabel)
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

  var postComments: some View {
    PostButtonItem(
      text: String(post.postCommentCount ?? 0),
      icon: .bubbleLeftCircleFill,
      color: Color.gray
    )
  }

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

struct CompactPostsView_Previews: PreviewProvider {
  static var previews: some View {
    let samplePost = RealmPost(
      postID: 1,
      postName:
      "Sonoma. This is the body of the sample post. It contains some information about the post.",
      postPublished: "2023-09-15T12:33:03.503139",
      postURL: "https://example.com/sample-post",
      postBody: "This is the body of the sample post. It contains some information about the post.",
      postThumbnailURL: "https://i.imgur.com/bgHfktp.jpeg",
      personID: 1,
      personName: "mani",
      personPublished: "October 17, 2023",
      personActorID: "mani01",
      personInstanceID: 123,
      personAvatar: "https://i.imgur.com/cflaISU.jpeg",
      personDisplayName: "Mani",
      personBio: "Just a sample user on this platform.",
      personBanner: "",
      communityID: 1,
      communityName: "SampleCommunity",
      communityTitle: "Welcome to the Sample Community",
      communityActorID: "https://lemmy.world/c/worldnews",
      communityInstanceID: 456,
      communityDescription:
      "This is a sample community description. It provides information about the community.",
      communityIcon: "https://example.com/community-icon.jpg",
      communityBanner: "https://example.com/community-banner.jpg",
      communityUpdated: "October 16, 2023",
      postScore: 42,
      postCommentCount: 10,
      upvotes: 30,
      downvotes: 12,
      postMyVote: 1,
      postHidden: false,
      postMinimised: false,
      sort: "Active",
      type: "All",
      filterKey: "sortAndTypeOnly"
    )
    return CompactPostItem(post: samplePost).previewLayout(.sizeThatFits)
  }
}

//
//  LegacyPostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import BetterSafariView
import Defaults
import SFSafeSymbols
import SwiftUI

struct LegacyPostRowView: View {
  @Default(.activeAccount) var activeAccount
  @Default(.subscribedCommunityIDs) var subscribedCommunityIDs
  @Default(.legacyPostsViewStyle) var legacyPostsViewStyle

  @Binding var upvoted: Bool
  @Binding var downvoted: Bool

  @State var upvoteState: Int = 0
  @State var downvoteState: Int = 0
  @State var goInto: Bool = false
  @State var showingPlaceholderAlert = false
  @State var subscribeState: SubscribedState = .notSubscribed
  @State var isSubscribed: Bool
  @State private var showSafari: Bool = false
  @State private var showCommunityActions: Bool = false

  var post: PostObject
  var insideCommentsView: Bool = false

  var compactViewEnabled: Bool {
    legacyPostsViewStyle == "compactPlain"
  }

  var imageURL: String {
    if let thumbnailURL = post.post.thumbnailURL, !thumbnailURL.isEmpty {
      return thumbnailURL
    } else if let postURL = post.post.url, !postURL.isEmpty, postURL.isValidExternalImageURL() {
      return postURL
    }
    return ""
  }

  var communityName: String { post.community.name }
  var heading: String { post.post.name }
  var creator: String { post.creator.name }
  var upvotes: Int { post.counts.upvotes ?? 0 }
  var downvotes: Int { post.counts.downvotes ?? 0 }
  var commentCount: Int { post.counts.comments ?? 0 }
  var postID: Int { post.post.id }

  var instanceTag: String {
    let tag = post.community.actorID
    if !tag.isEmpty {
      let instanceTag = "@\(URLParser.extractDomain(from: tag))"
      return instanceTag
    } else {
      return ""
    }
  }

  var timeAgo: String {
    ", \(TimestampParser().parse(originalTimestamp: post.post.published) ?? "") ago"
  }

  let haptics = UIImpactFeedbackGenerator(style: .rigid)

  var body: some View {
    if compactViewEnabled, !insideCommentsView {
      HStack {
        InPostThumbnailView(
          thumbnailURL: imageURL,
          imageRadius: 4
        )
        .frame(width: 80)
        Spacer()
      }
    }
    VStack {
      if !compactViewEnabled || insideCommentsView {
        if !imageURL.isEmpty {
          InPostThumbnailView(thumbnailURL: imageURL)
          Spacer()
        }
      }
      HStack {
        if compactViewEnabled, !insideCommentsView {
          if !imageURL.isEmpty {
            Rectangle()
              .disabled(true)
              .opacity(0)
              .frame(width: 80)
              .padding(.trailing, 10)
          }
        }
        VStack(alignment: .leading, spacing: 5) {
          HStack {
            Text("\(communityName)\(instanceTag)")
              .textCase(.lowercase)
              .foregroundColor(.secondary)
              .highPriorityGesture(
                TapGesture().onEnded {
                  haptics.impactOccurred(intensity: 0.5)
                  showCommunityActions = true
                }
              )
            switch subscribeState {
            case .notSubscribed:
              EmptyView()
            case .pending:
              Image(systemSymbol: .clockArrow2Circlepath)
            case .subscribed:
              Image(systemSymbol: .checkmarkCircle)
            }
            Spacer()
            if compactViewEnabled {
              compactViewReactionButtons
            }
          }
          .font(.caption)
          .confirmationDialog(
            "\(communityName)\(instanceTag)", isPresented: $showCommunityActions,
            titleVisibility: .visible
          ) {
            Button {
              sendSubscribeAction(subscribeAction: !isSubscribed)
              isSubscribed.toggle()
            } label: {
              Text(isSubscribed ? "Unsubscribe" : "Subscribe")
            }
          }

          Text(heading)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          HStack {
            Text("\(creator.uppercased())\(timeAgo)")
              .foregroundColor(.secondary)

            if compactViewEnabled {
              Spacer()
              if post.post.url != post.post.thumbnailURL {
                compactSafariButton
              }
            }
          }
          .font(.caption)
        }
        .layoutPriority(100)
        Spacer()
      }
      if !compactViewEnabled {
        HStack {
          upvoteButton
          downvoteButton
          commentButton
          Spacer()
          if post.post.url != post.post.thumbnailURL {
            safariButton
          }
        }
      }
    }
    .padding(.horizontal, -5)
    .padding(.vertical, imageURL.isEmpty ? 0 : 10)
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      GoIntotSwipeAction(isClicked: $goInto)
    }
    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      UpvoteSwipeAction(isClicked: $showingPlaceholderAlert)
      DownvoteSwipeAction(isClicked: $showingPlaceholderAlert)
    }
    .contextMenu {
      PostContextMenu(showingPlaceholderAlert: $showingPlaceholderAlert)
    }
    .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
      Button("OK", role: .cancel) {
        showingPlaceholderAlert = false
      }
    }
    .onAppear { updateVotesOnAppear() }
  }

  var compactViewReactionButtons: some View {
    HStack {
      HStack(spacing: 1) {
        Image(systemSymbol: .arrowUp)
        Text(String(upvotes + upvoteState))
          .fixedSize()
      }
      .lineLimit(1)
      .foregroundStyle(.green)
      .highPriorityGesture(
        TapGesture().onEnded {
          haptics.impactOccurred()
          if !upvoted {
            print("SENT /post/like \(String(describing: postID)):upvote(+1)")
            sendReaction(
              voteType: 1, postID: post.post.id
            )
          } else {
            print("SENT /post/like \(String(describing: postID)):un-upvote(0)")
            sendReaction(
              voteType: 0, postID: post.post.id
            )
          }
        }
      )

      HStack(spacing: 1) {
        Image(systemSymbol: .arrowDown)
        Text(String(downvotes + downvoteState))
          .fixedSize()
      }
      .lineLimit(1)
      .foregroundStyle(.red)
      .highPriorityGesture(
        TapGesture().onEnded {
          haptics.impactOccurred()
          if !downvoted {
            sendReaction(
              voteType: -1, postID: post.post.id
            )
          } else {
            sendReaction(
              voteType: 0, postID: post.post.id
            )
          }
        }
      )

      HStack(spacing: 2) {
        Image(systemSymbol: .bubbleLeft)
        Text(String(commentCount))
          .fixedSize()
      }
      .lineLimit(1)
      .foregroundStyle(.gray)
    }
  }

  var commentButton: some View {
    ReactionButton(
      text: String(commentCount),
      icon: SFSafeSymbols.SFSymbol.bubbleLeftCircleFill,
      color: Color.gray,
      active: .constant(false),
      opposite: .constant(false)
    )
  }

  var safariButton: some View {
    ReactionButton(
      text: "\(URLParser.extractBaseDomain(from: post.post.url ?? "")) ",
      icon: SFSafeSymbols.SFSymbol.globe,
      color: Color.blue,
      active: .constant(false),
      opposite: .constant(false)
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        showSafari.toggle()
      }
    )
    .inAppSafari(isPresented: $showSafari, stringURL: post.post.url ?? "")
  }

  var upvoteButton: some View {
    ReactionButton(
      text: String(upvotes + upvoteState),
      icon: SFSafeSymbols.SFSymbol.arrowUpCircleFill,
      color: Color.green,
      active: $upvoted,
      opposite: .constant(false)
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        haptics.impactOccurred()
        if !upvoted {
          print("SENT /post/like \(String(describing: postID)):upvote(+1)")
          sendReaction(
            voteType: 1, postID: post.post.id
          )
        } else {
          print("SENT /post/like \(String(describing: postID)):un-upvote(0)")
          sendReaction(
            voteType: 0, postID: post.post.id
          )
        }
      }
    )
  }

  var downvoteButton: some View {
    ReactionButton(
      text: String(downvotes + downvoteState),
      icon: SFSafeSymbols.SFSymbol.arrowDownCircleFill,
      color: Color.red,
      active: $downvoted,
      opposite: .constant(false)
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        haptics.impactOccurred()
        if !downvoted {
          sendReaction(
            voteType: -1, postID: post.post.id
          )
        } else {
          sendReaction(
            voteType: 0, postID: post.post.id
          )
        }
      }
    )
  }

  var compactSafariButton: some View {
    HStack(spacing: 2) {
      Image(systemSymbol: .globe)
      Text("\(URLParser.extractBaseDomain(from: post.post.url ?? "")) ")
        .fixedSize()
    }
    .lineLimit(1)
    .foregroundStyle(.blue)
    .highPriorityGesture(
      TapGesture().onEnded {
        showSafari.toggle()
      }
    )
    .inAppSafari(isPresented: $showSafari, stringURL: post.post.url ?? "")
  }

  func sendSubscribeAction(subscribeAction: Bool) {
    let notificationHaptics = UINotificationFeedbackGenerator()
    SubscriptionActionSender(
      communityID: post.community.id,
      asActorID: activeAccount.actorID,
      subscribeAction: subscribeAction
    ).fetchSubscribeInfo { _, subscribeResponse, _ in
      if subscribeResponse != nil {
        notificationHaptics.notificationOccurred(.success)

        // MARK: - TODO: Find an alternate to updating the state after subscribe action without using Env Object

        //        if let index = postsFetcher.posts.firstIndex(where: { $0.post.id == post.post.id }) {
        //          var updatedPost = postsFetcher.posts[index]
        //          updatedPost.subscribed = subscribeAction ? .subscribed : .notSubscribed
        //          postsFetcher.posts[index] = updatedPost
        //          subscribeState = subscribeAction ? .subscribed : .notSubscribed // Update the local subscription status
        //        }
        if subscribeResponse == .subscribed {
          subscribedCommunityIDs.append(post.community.id)
        } else if subscribeResponse == .notSubscribed {
          if let index = subscribedCommunityIDs.firstIndex(of: post.community.id) {
            subscribedCommunityIDs.remove(at: index)
          }
        }
      }
    }
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
      if voteSubmittedSuccessfully {
        switch voteType {
        case 1:
          upvoted = true
          downvoted = false
          upvoteState = 1
          downvoteState = 0
        case -1:
          upvoted = false
          downvoted = true
          upvoteState = 0
          downvoteState = 1
        default:
          upvoted = false
          downvoted = false
          upvoteState = 0
          downvoteState = 0
        }

        // MARK: - TODO: Find an alternate to updating the state after subscribe action without using Env Object

        //        // Update the corresponding post in the postsFetcher.posts array
        //        if let index = postsFetcher.posts.firstIndex(where: { $0.post.id == postID }) {
        //          var updatedPost = postsFetcher.posts[index]
        //          updatedPost.myVote = voteType
        //          postsFetcher.posts[index] = updatedPost
        //        }
      }
    }
  }

  func updateVotesOnAppear() {
    if let voteType = post.myVote {
      switch voteType {
      case 1:
        upvoted = true
        downvoted = false
        upvoteState = 1
        downvoteState = 0
      case -1:
        upvoted = false
        downvoted = true
        upvoteState = 0
        downvoteState = 1
      default:
        upvoted = false
        downvoted = false
        upvoteState = 0
        downvoteState = 0
      }
    }
  }
}

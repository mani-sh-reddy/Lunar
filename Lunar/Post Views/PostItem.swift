//
//  PostItem.swift
//  Lunar
//
//  Created by Mani on 24/10/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct PostItem: View {
  @Default(.debugModeEnabled) var debugModeEnabled
  @Default(.activeAccount) var activeAccount

  @ObservedRealmObject var post: RealmPost

  @State var showSafari: Bool = false
  @State var subscribeAlertPresented: Bool = false
  @State var reportPostSheetPresented: Bool = false
  @State var blockUserDialogPresented: Bool = false
  @State var reportReasonHolder: String = ""

  @Environment(\.dismiss) var dismissReportPostSheet

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
      if post.postMinimised {
        if post.postFeatured {
          postMinimisedFeatured
        } else {
          postMinimised
        }
      } else {
        VStack(alignment: .leading, spacing: 7) {
          postImage
          HStack {
            postCommunityLabel
          }
          postTitle
          postCreatorLabel
          HStack(spacing: 5) {
            postUpvotes
            postDownvotes
            postComments
            Spacer()
            postWebLink
          }
          if debugModeEnabled {
            debugValues
          }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
      }
      commentsNavLink
    }

    .listRowSeparator(.hidden)
    .padding(.vertical, 5)
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
      shareButton
      Menu {
        reportPostButton
        blockUserButton
      } label: {
        Label("More", systemSymbol: .ellipsisCircle)
      }
    }
    .confirmationDialog("", isPresented: $blockUserDialogPresented) {
      blockDialog
    } message: {
      Text("Block user \(URLParser.buildFullUsername(from: post.personActorID))")
    }
    .sheet(isPresented: $reportPostSheetPresented) {
      reportSheet
    }
  }

  var reportSheet: some View {
    List {
      Section {
        HStack {
          Text("Report Post")
            .font(.title)
            .bold()
          Spacer()
          Button {
            reportPostSheetPresented = false
          } label: {
            Image(systemSymbol: .xmarkCircleFill)
              .font(.largeTitle)
              .foregroundStyle(.secondary)
              .saturation(0)
          }
        }
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      Section {
        VStack(alignment: .leading) {
          Text(URLParser.buildFullUsername(from: post.personActorID))
            .foregroundStyle(.secondary)
          Text(post.postName)
            .lineLimit(5)
            .truncationMode(.tail)
        }
      } header: {
        Text("Post")
      }
      .listRowSeparator(.hidden)
      .listRowBackground(Color.clear)

      Section {
        TextEditor(text: $reportReasonHolder)
          .background(Color.clear)
          .font(.body)
          .frame(height: 150)
      } header: {
        Text("Reason")
      }

      Section {
        Button {
          let reportReason = reportReasonHolder
          reportPostAction(reportReason: reportReason)
        } label: {
          Text("Report")
        }
        .tint(.red)
        .disabled(reportReasonHolder.isEmpty)
        Button {
          let reportReason = reportReasonHolder
          reportPostAction(reportReason: reportReason)
          blockUserAction()
        } label: {
          Text("Report and Block User")
        }
        .tint(.red)
        .disabled(reportReasonHolder.isEmpty)
      }
    }
  }

  @ViewBuilder
  var blockDialog: some View {
    Button("Block User") {
      blockUserAction()
    }
    Button("Report & Block") {
      blockUserDialogPresented = false
      reportPostSheetPresented = true
    }
    Button("Dismiss", role: .cancel) {
      blockUserDialogPresented = false
    }
  }

  var reportPostButton: some View {
    Button {
      reportPostSheetPresented = true
    } label: {
      Label("Report Post", systemSymbol: AllSymbols().reportContextIcon)
    }
  }

  var blockUserButton: some View {
    Button {
      blockUserDialogPresented = true
    } label: {
      Label("Block User", systemSymbol: AllSymbols().blockContextIcon)
    }
  }

  var shareButton: some View {
    Button {
      var items: [Any] = [post.postName]
      if post.postThumbnailURL != nil || post.postURL != nil {
        items = [URL(string: post.postThumbnailURL ?? post.postURL!)!, post.postName]
      } else if post.postBody != nil {
        items = [post.postName, post.postBody as Any]
      }
      ShareSheet().share(items: items) {}
    } label: {
      Label("Share", systemSymbol: AllSymbols().shareContextIcon)
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
    HStack(spacing: 3) {
      Text(communityLabel)
      if post.communitySubscribed != nil, post.communitySubscribed == .subscribed {
        Image(systemSymbol: .bookmark)
      } else if post.communitySubscribed != nil, post.communitySubscribed == .pending {
        Image(systemSymbol: .clock)
      }
    }
    .textCase(.lowercase)
    .foregroundColor(.secondary)
    .font(.caption)
    .highPriorityGesture(
      TapGesture().onEnded {
        hapticsLight.impactOccurred()
        subscribeAlertPresented = true
      }
    )
    .confirmationDialog("", isPresented: $subscribeAlertPresented) {
      if post.communitySubscribed == .notSubscribed {
        Button("Subscribe") {
          sendSubscribeAction(subscribeAction: true)
        }
      } else {
        Button("Unsubscribe") {
          sendSubscribeAction(subscribeAction: false)
        }
      }
      Button("Dismiss", role: .cancel) {
        subscribeAlertPresented = false
      }
    } message: {
      Text("\(post.communityName)@\(URLParser.extractDomain(from: post.communityActorID))")
    }
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

  var debugValues: some View {
    VStack(alignment: .leading) {
      DebugTextView(name: "communityID", value: String(describing: post.communityID))
      DebugTextView(name: "communityActorID", value: post.communityActorID)
      DebugTextView(name: "sort", value: post.sort)
      DebugTextView(name: "type", value: post.type)
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
    }
  }

  func sendSubscribeAction(subscribeAction: Bool) {
    let notificationHaptics = UINotificationFeedbackGenerator()
    if let communityID = post.communityID {
      SubscriptionActionSender(
        communityID: communityID,
        asActorID: activeAccount.actorID,
        subscribeAction: subscribeAction
      ).fetchSubscribeInfo { _, subscribeResponse, _ in
        let realm = try! Realm()
        if subscribeResponse != nil {
          notificationHaptics.notificationOccurred(.success)
          try! realm.write {
            let community = RealmCommunity(
              id: communityID,
              name: post.communityName,
              title: post.communityTitle,
              actorID: post.communityActorID,
              instanceID: post.communityInstanceID,
              descriptionText: post.communityDescription,
              icon: post.communityIcon,
              banner: post.communityBanner,
              postingRestrictedToMods: false,
              published: "",
              subscribers: nil,
              posts: nil,
              comments: nil,
              subscribed: subscribeResponse ?? .notSubscribed
            )
            realm.add(community, update: .modified)
          }
          RealmThawFunctions().subscribe(post: post, subscribedState: subscribeResponse ?? .notSubscribed)
        } else {
          notificationHaptics.notificationOccurred(.error)
        }
      }
    }
  }

  func blockUserAction() {
    if let personID = post.personID {
      BlockSender(personID: personID, blockableObjectType: .person, block: true).blockUser { _, isBlockedResponse, _ in
        if isBlockedResponse == true {
          RealmThawFunctions().deletePost(post: post)
        }
      }
    }
  }

  func reportPostAction(reportReason: String) {
    ReportSender(postID: post.postID, reportObjectType: .post, reportReason: reportReason).sendReport { _, _, successful in
      print(successful)
      if successful == true {
        notificationHaptics.notificationOccurred(.success)
        reportPostSheetPresented = false
      } else {
        notificationHaptics.notificationOccurred(.error)
      }
    }
  }
}

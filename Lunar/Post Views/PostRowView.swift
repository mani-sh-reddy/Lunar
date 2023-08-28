//
//  PostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI
import SafariServices

struct PostRowView: View {
  @EnvironmentObject var postsFetcher: PostsFetcher
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  @AppStorage("subscribedCommunityIDs") var subscribedCommunityIDs = Settings.subscribedCommunityIDs
  
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  
  @State var upvoteState: Int = 0
  @State var downvoteState: Int = 0
  
  @State var goInto: Bool = false
  @State var showingPlaceholderAlert = false
  @State private var showSafari: Bool = false
  @State var subscribeState: SubscribedState = .notSubscribed
  @State var isSubscribed: Bool
  
  var post: PostElement
  
  var imageURL: String {
    if let thumbnailURL = post.post.thumbnailURL, !thumbnailURL.isEmpty {
      return thumbnailURL
    } else if let postURL = post.post.url, !postURL.isEmpty, postURL.isValidExternalImageURL() {
      return postURL
    }
    return ""
  }
  
  var communityName: String { return post.community.name }
  var heading: String { return post.post.name }
  var creator: String { return post.creator.name }
  var published: String { return post.post.published }
  var upvotes: Int { return post.counts.upvotes }
  var downvotes: Int { return post.counts.downvotes }
  var commentCount: Int { return post.counts.comments }
  var postID: Int { return post.post.id }
  var instanceTag: String {
    let tag = post.community.actorID
    if !tag.isEmpty {
      let instanceTag = "@\(URLParser.extractDomain(from: tag))"
      return instanceTag
    } else {
      return ""
    }
  }
  
  let dateTimeParser = DateTimeParser()
  var timeAgo: String {
    return ", \(dateTimeParser.timeAgoString(from: post.post.published))"
  }
  
  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  @State private var showCommunityActions: Bool = false
  
  var body: some View {
    VStack {
      if !imageURL.isEmpty {
        InPostThumbnailView(thumbnailURL: imageURL)
        Spacer()
      }
      HStack {
        VStack(alignment: .leading, spacing: 5) {
          HStack{
            Text("\(communityName)\(instanceTag)")
              .textCase(.lowercase)
            switch subscribeState {
            case .notSubscribed:
              EmptyView()
            case .pending:
              Image(systemName: "clock.arrow.2.circlepath")
            case .subscribed:
              Image(systemName: "checkmark.circle")
            }
          }
          .font(.caption)
          .foregroundColor(.secondary)
          .highPriorityGesture(
            TapGesture().onEnded {
              haptics.impactOccurred(intensity: 0.5)
              showCommunityActions = true
            }
          )
          .confirmationDialog("\(communityName)\(instanceTag)", isPresented: $showCommunityActions, titleVisibility: .visible) {
            Button {
              sendSubscribeAction(subscribeAction: !isSubscribed)
              isSubscribed.toggle()
            } label: {
              Text(isSubscribed ? "Unsubscribe" : "Subscribe")
            }
          }
//          .confirmationDialog("\(communityName)\(instanceTag)", isPresented: $showCommunityActions, titleVisibility: .visible) {
//            Button {
//              switch subscribeState {
//              case .notSubscribed:
//                subscribeAction(subscribeAction: true)
//              case .pending:
//                subscribeAction(subscribeAction: false)
//              case .subscribed:
//                subscribeAction(subscribeAction: false)
//              }
//            } label: {
//              switch subscribeState {
//              case .notSubscribed:
//                Text("Subscribe")
//              case .pending:
//                Text("Unsubscribe (Pending Subscription)")
//              case .subscribed:
//                Text("Unsubscribe")
//              }
//            }
//          }
//          .onAppear {
//            if let index = postsFetcher.posts.firstIndex(where: { $0.post.id == post.post.id }) {
//              subscribeState = postsFetcher.posts[index].subscribed
//              
//              // Sync subscription state with UserDefaults on first appear
//              let subscriptionKey = "\(communityName)\(instanceTag)"
//              if let savedSubscriptionState = UserDefaults.standard.value(forKey: subscriptionKey) as? Bool {
//                subscribeState = savedSubscriptionState ? .subscribed : .notSubscribed
//              }
//            }
//          }
          
          Text(heading)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          Text("\(creator.uppercased())\(timeAgo)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .layoutPriority(100)
        Spacer()
      }
      HStack {
        ReactionButton(
          text: String(upvotes + upvoteState),
          icon: "arrow.up.circle.fill",
          color: Color.green,
          active: $upvoted,
          opposite: .constant(false)
        )
        .highPriorityGesture(
          TapGesture().onEnded {
            haptics.impactOccurred()
            if !upvoted {
              print("SENT /post/like \(String(describing: postID)):upvote(+1)")
              sendReaction(voteType: 1, postID: post.post.id, communityActorID: post.community.actorID)
            } else {
              print("SENT /post/like \(String(describing: postID)):un-upvote(0)")
              sendReaction(voteType: 0, postID: post.post.id, communityActorID: post.community.actorID)
            }
          }
        )
        
        ReactionButton(
          text: String(downvotes + downvoteState),
          icon: "arrow.down.circle.fill",
          color: Color.red,
          active: $downvoted,
          opposite: .constant(false)
        )
        .highPriorityGesture(
          TapGesture().onEnded {
            haptics.impactOccurred()
            if !downvoted {
              sendReaction(voteType: -1, postID: post.post.id, communityActorID: post.community.actorID)
            } else {
              sendReaction(voteType: 0, postID: post.post.id, communityActorID: post.community.actorID)
            }
          }
        )
        
        ReactionButton(
          text: String(commentCount),
          icon: "bubble.left.circle.fill",
          color: Color.gray,
          active: .constant(false),
          opposite: .constant(false)
        )
        
        Spacer()
        if post.post.url != post.post.thumbnailURL {
          ReactionButton(
            text: "\(URLParser.extractBaseDomain(from: post.post.url ?? "")) ",
            icon: "safari.fill",
            color: Color.blue,
            //            iconSize: Font.title2,
            //            padding: 1,
            active: .constant(false),
            opposite: .constant(false)
          )
          .highPriorityGesture(
            TapGesture().onEnded {
              showSafari.toggle()
            }
          )
          .fullScreenCover(isPresented: $showSafari, content: {
            SFSafariViewWrapper(url: URL(string: post.post.url ?? "")!).ignoresSafeArea()
          })
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
    .onAppear {
      if let voteType = post.myVote {
        switch voteType {
        case 1:
          self.upvoted = true
          self.downvoted = false
          upvoteState = 1
          downvoteState = 0
        case -1:
          self.upvoted = false
          self.downvoted = true
          upvoteState = 0
          downvoteState = 1
        default:
          self.upvoted = false
          self.downvoted = false
          upvoteState = 0
          downvoteState = 0
        }
      }
    }
  }
  
  func sendSubscribeAction(subscribeAction: Bool) {
    let notificationHaptics = UINotificationFeedbackGenerator()
    SubscriptionActionSender(
      communityID: post.community.id,
      asActorID: selectedActorID,
      subscribeAction: subscribeAction
    ).fetchSubscribeInfo { communityID, subscribeResponse, error in
      if subscribeResponse != nil {
        notificationHaptics.notificationOccurred(.success)
        if let index = postsFetcher.posts.firstIndex(where: { $0.post.id == post.post.id }) {
          var updatedPost = postsFetcher.posts[index]
          updatedPost.subscribed = subscribeAction ? .subscribed : .notSubscribed
          postsFetcher.posts[index] = updatedPost
          subscribeState = subscribeAction ? .subscribed : .notSubscribed // Update the local subscription status
        }
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
  
  
  func sendReaction(voteType: Int, postID: Int, communityActorID: String) {
    VoteSender(
      asActorID: selectedActorID,
      voteType: voteType,
      postID: postID,
      communityActorID: communityActorID,
      commentID: 0,
      elementType: "post"
    ).fetchVoteInfo { postID, voteSubmittedSuccessfully, _ in
      print("RETURNED /post/like \(String(describing: postID)):\(voteSubmittedSuccessfully)")
      if voteSubmittedSuccessfully {
        switch voteType {
        case 1:
          self.upvoted = true
          self.downvoted = false
          upvoteState = 1
          downvoteState = 0
        case -1:
          self.upvoted = false
          self.downvoted = true
          upvoteState = 0
          downvoteState = 1
        default:
          self.upvoted = false
          self.downvoted = false
          upvoteState = 0
          downvoteState = 0
        }
            
        // Update the corresponding post in the postsFetcher.posts array
        if let index = postsFetcher.posts.firstIndex(where: { $0.post.id == postID }) {
          var updatedPost = postsFetcher.posts[index]
          updatedPost.myVote = voteType
          postsFetcher.posts[index] = updatedPost
        }
      }
    }
  }
}

struct PostRowView_Previews: PreviewProvider {
  static var previews: some View {
    PostRowView(
      upvoted: .constant(false),
      downvoted: .constant(false),
      isSubscribed: false, post: MockData.postElement
    )
    .previewLayout(.sizeThatFits).frame(height: 300)
  }
}

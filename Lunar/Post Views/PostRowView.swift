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
  
  @Binding var upvoted: Bool
  @Binding var downvoted: Bool
  
  @State var goInto: Bool = false
  @State var showingPlaceholderAlert = false
  @State private var showSafari: Bool = false
  
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
  
  var body: some View {
    VStack {
      if !imageURL.isEmpty {
        InPostThumbnailView(thumbnailURL: imageURL)
        Spacer()
      }
      HStack {
        VStack(alignment: .leading, spacing: 5) {
          Text("\(communityName)\(instanceTag)")
            .textCase(.lowercase)
            .font(.caption)
            .foregroundColor(.secondary)
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
          text: String(upvoted ? upvotes + 1 : upvotes),
          icon: "arrow.up.circle.fill",
          color: Color.green,
          active: $upvoted,
          opposite: .constant(false)
        )
        .highPriorityGesture(
          TapGesture().onEnded {
            haptics.impactOccurred()
            upvoted.toggle()
            downvoted = false
            if upvoted {
              sendReaction(voteType: 1, postID: post.post.id)
            } else {
              sendReaction(voteType: 0, postID: post.post.id)
            }
          }
        )

        ReactionButton(
          text: String(downvoted ? downvotes + 1 : downvotes),
          icon: "arrow.down.circle.fill",
          color: Color.red,
          active: $downvoted,
          opposite: .constant(false)
        )
        .highPriorityGesture(
          TapGesture().onEnded {
            haptics.impactOccurred()
            downvoted.toggle()
            upvoted = false
            if downvoted {
              sendReaction(voteType: -1, postID: post.post.id)
            } else {
              sendReaction(voteType: 0, postID: post.post.id)
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
            iconSize: Font.title2,
            padding: 1,
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
          case -1:
            self.upvoted = false
            self.downvoted = true
          default:
            self.upvoted = false
            self.downvoted = false
          }
        }
    }
  }
  
  func sendReaction(voteType: Int, postID: Int) {
    VoteSender(
      asActorID: selectedActorID,
      voteType: voteType,
      postID: postID,
      commentID: 0,
      elementType: "post"
    ).fetchVoteInfo { postID, voteSubmittedSuccessfully, _ in
      if voteSubmittedSuccessfully {
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

struct GoIntoButtonView: View {
  @Binding var isClicked: Bool
  
  var body: some View {
    Button {
      isClicked = true
    } label: {
      Image(systemName: "chevron.forward.circle.fill")
    }
    .tint(.blue)
  }
}

struct UpvoteButtonView: View {
  @Binding var isClicked: Bool
  
  var body: some View {
    Button {
      isClicked = true
    } label: {
      Image(systemName: "arrow.up.circle")
    }
    .tint(.green)
  }
}

struct DownvoteButtonView: View {
  @Binding var isClicked: Bool
  
  var body: some View {
    Button {
      isClicked = true
    } label: {
      Image(systemName: "arrow.down.circle")
    }
    .tint(.red)
  }
}

struct HapticMenuView: View {
  @Binding var showingPlaceholderAlert: Bool
  
  var body: some View {
    Menu("Menu") {
      Button {
        showingPlaceholderAlert = true
      } label: {
        Text("Coming Soon")
      }
    }
    Button {
      showingPlaceholderAlert = true
    } label: {
      Text("Coming Soon")
    }
    
    Divider()
    
    Button(role: .destructive) {
      showingPlaceholderAlert = true
    } label: {
      Label("Delete", systemImage: "trash")
    }
  }
}

struct ReactionButtonView: View {
  var text: String
  var icon: String
  var color: Color
  
  @Binding var active: Bool
  @Binding var opposite: Bool
  
  let haptics = UIImpactFeedbackGenerator(style: .rigid)
  
  var body: some View {
    Button {
      active.toggle()
      opposite = false
      haptics.impactOccurred()
    } label: {
      HStack {
        Image(systemName: icon)
        Text(text)
          .font(.subheadline)
      }
      .foregroundStyle(active ? Color.white : color)
      .symbolRenderingMode(
        active ? SymbolRenderingMode.monochrome : SymbolRenderingMode.hierarchical
      )
    }
    .buttonStyle(BorderlessButtonStyle())
    .padding(5).padding(.trailing, 3)
    .background(active ? color.opacity(0.75) : .secondary.opacity(0.1), in: Capsule())
    .padding(.top, 3)
  }
}

struct PostRowView_Previews: PreviewProvider {
  static var previews: some View {
    PostRowView(upvoted: .constant(true), downvoted: .constant(false), post: MockData.postElement)
  }
}

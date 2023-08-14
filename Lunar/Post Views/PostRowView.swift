//
//  PostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct PostRowView: View {
  @State var upvoted: Bool = false
  @State var downvoted: Bool = false
  @State var goInto: Bool = false
  
  @State var showingPlaceholderAlert = false
  
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
  
  var post: PostElement
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
          text: String(upvotes),
          icon: "arrow.up.circle.fill",
          color: Color.green,
          active: $upvoted,
          opposite: $downvoted
        )
        .onTapGesture {
          upvoted.toggle()
          downvoted = false
        }
        ReactionButton(
          text: String(downvotes),
          icon: "arrow.down.circle.fill",
          color: Color.red,
          active: $downvoted,
          opposite: $upvoted
        )
        .onTapGesture {
          downvoted.toggle()
          upvoted = false
        }
        ReactionButton(
          text: String(commentCount),
          icon: "bubble.left.circle.fill",
          color: Color.gray,
          active: .constant(false),
          opposite: .constant(false)
        )
        Spacer()
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

//struct PostRowView_Previews: PreviewProvider {
//  static var previews: some View {
//    PostRowView(post: MockData.post).padding()
//  }
//}

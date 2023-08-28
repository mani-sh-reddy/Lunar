//
//  KbinPostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

struct KbinPostRowView: View {
  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL

  var post: KbinPost
  @State var showingPlaceholderAlert: Bool = false
  @State var goInto: Bool = false

  @State var upvoted: Bool = false
  @State var downvoted: Bool = false

  var magazine: String {
    if post.instanceLink != nil, post.instanceLink != "" {  // skipcq: SW-P1006
      return "\(post.magazine)@\(post.instanceLink ?? "")"
    } else {
      return "\(post.magazine)"
    }
  }

  var body: some View {
    VStack {
      if !post.imageUrl.isEmpty {
        InPostThumbnailView(thumbnailURL: post.imageUrl)
        Spacer()
      }
      HStack {
        VStack(alignment: .leading, spacing: 5) {
          Text(magazine)
            .textCase(.lowercase)
            .font(.caption)
            .foregroundColor(.secondary)
          Text(post.title)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          Text("\(post.user.uppercased()), \(post.timeAgo)")
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .layoutPriority(100)
        Spacer()
      }
      HStack {
        ReactionButton(
          text: String(post.upvotes),
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
          text: String(post.downvotes),
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
          text: String(post.commentsCount),
          icon: "bubble.left.circle.fill",
          color: Color.gray,
          active: .constant(false),
          opposite: .constant(false)
        )
        Spacer()
      }
    }
    .padding(.horizontal, -5)
    .padding(.vertical, post.imageUrl.isEmpty ? 0 : 10)
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

struct KbinPostRowView_Previews: PreviewProvider {
  static var previews: some View {
    KbinPostRowView(post: MockData.kbinPost)
  }
}

struct GoIntotSwipeAction: View {
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

struct UpvoteSwipeAction: View {
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

struct DownvoteSwipeAction: View {
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

struct PostContextMenu: View {
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

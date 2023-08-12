//
//  PostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

//struct PostRowView: View {
//  var post: PostElement
//
//  @State var showingPlaceholderAlert = false
//
//  @State var upvoted: Bool = false
//  @State var downvoted: Bool = false
//
//  let haptics = UIImpactFeedbackGenerator(style: .rigid)
//
//  var body: some View {
//    VStack(alignment: .leading) {
//      Text(post.post.name)
//        .font(.headline)
//        .multilineTextAlignment(.leading)
//
//      InPostCommunityHeaderView(community: post.community)
//        .padding(.vertical, 1)
//
//      if let thumbnailURL = post.post.thumbnailURL {
//        InPostThumbnailView(thumbnailURL: thumbnailURL)
//      } else if let url = post.post.url, url.isValidExternalImageURL() {
//        InPostThumbnailView(thumbnailURL: url)
//      } else {
//        EmptyView()
//      }
//
//      HStack(spacing: 6) {
//        InPostUserView(
//          text: post.creator.name,
//          iconName: "person.crop",
//          userAvatar: post.creator.avatar
//        )
//        Spacer(minLength: 20)
//
//        InPostMetadataView(
//          bodyText: String(post.counts.upvotes),
//          iconName: "arrow.up.circle.fill",
//          iconColor: upvoted ? .green : .gray
//        )
//        .onTapGesture {
//          downvoted = false
//          upvoted.toggle()
//          haptics.impactOccurred()
//        }
//
//        InPostMetadataView(
//          bodyText: String(post.counts.downvotes),
//          iconName: "arrow.down.circle.fill",
//          iconColor: downvoted ? .red : .gray
//        )
//        .onTapGesture {
//          upvoted = false
//          downvoted.toggle()
//          haptics.impactOccurred()
//        }
//
//        InPostMetadataView(
//          bodyText: String(post.counts.comments),
//          iconName: "bubble.left.circle.fill",
//          iconColor: .gray
//        )
//      }
//    }
//
//    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//      Button {
//        showingPlaceholderAlert = true
//      } label: {
//        Image(systemName: "chevron.forward.circle.fill")
//      }.tint(.blue)
//    }
//
//    .swipeActions(edge: .leading, allowsFullSwipe: false) {
//      Button {
//        showingPlaceholderAlert = true
//      } label: {
//        Image(systemName: "arrow.up.circle")
//      }.tint(.green)
//      Button {
//        showingPlaceholderAlert = true
//      } label: {
//        Image(systemName: "arrow.down.circle")
//      }.tint(.red)
//    }
//
//    .contextMenu {
//      Menu("Menu") {
//        Button {
//          showingPlaceholderAlert = true
//        } label: {
//          Text("Coming Soon")
//        }
//      }
//
//      Button {
//        showingPlaceholderAlert = true
//      } label: {
//        Text("Coming Soon")
//      }
//
//      Divider()
//
//      Button(role: .destructive) {
//        showingPlaceholderAlert = true
//      } label: {
//        Label("Delete", systemImage: "trash")
//      }
//    }
//    .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
//      Button("OK", role: .cancel) {}
//    }
//  }
//}

struct PostRowView: View {
  @State var upvoted: Bool = false
  @State var downvoted: Bool = false
  @State var goInto: Bool = false
  
  @State var showingPlaceholderAlert = false
  
  var imageURL: String { return post.post.thumbnailURL ?? "" }
  var communityName: String { return post.community.name }
  var heading: String { return post.post.name }
  var creator: String { return post.creator.name }
  var published: String { return post.post.published }
  var upvotes: Int { return post.counts.upvotes }
  var downvotes: Int { return post.counts.downvotes }
  var commentCount: Int { return post.counts.comments }
  
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
          Text(communityName)
            .textCase(.lowercase)
            .font(.caption)
            .foregroundColor(.secondary)
          Text(heading)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
          Text("\(creator.uppercased()), \(published)")
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

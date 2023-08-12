//
//  PostRowView.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import Kingfisher
import SwiftUI

struct PostRowView: View {
  var post: PostElement

  @State var showingPlaceholderAlert = false

  @State var upvoted: Bool = false
  @State var downvoted: Bool = false

  let haptics = UIImpactFeedbackGenerator(style: .rigid)

  var body: some View {
    VStack(alignment: .leading) {
      Text(post.post.name)
        .font(.headline)
        .multilineTextAlignment(.leading)

      InPostCommunityHeaderView(community: post.community)
        .padding(.vertical, 1)

      if let thumbnailURL = post.post.thumbnailURL {
        InPostThumbnailView(thumbnailURL: thumbnailURL)
      } else if let url = post.post.url, url.isValidExternalImageURL() {
        InPostThumbnailView(thumbnailURL: url)
      } else {
        EmptyView()
      }

      HStack(spacing: 6) {
        InPostUserView(
          text: post.creator.name,
          iconName: "person.crop",
          userAvatar: post.creator.avatar
        )
        Spacer(minLength: 20)

        InPostMetadataView(
          bodyText: String(post.counts.upvotes),
          iconName: "arrow.up.circle.fill",
          iconColor: upvoted ? .green : .gray
        )
        .onTapGesture {
          downvoted = false
          upvoted.toggle()
          haptics.impactOccurred()
        }

        InPostMetadataView(
          bodyText: String(post.counts.downvotes),
          iconName: "arrow.down.circle.fill",
          iconColor: downvoted ? .red : .gray
        )
        .onTapGesture {
          upvoted = false
          downvoted.toggle()
          haptics.impactOccurred()
        }

        InPostMetadataView(
          bodyText: String(post.counts.comments),
          iconName: "bubble.left.circle.fill",
          iconColor: .gray
        )
      }
    }

    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      Button {
        showingPlaceholderAlert = true
      } label: {
        Image(systemName: "chevron.forward.circle.fill")
      }.tint(.blue)
    }

    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      Button {
        showingPlaceholderAlert = true
      } label: {
        Image(systemName: "arrow.up.circle")
      }.tint(.green)
      Button {
        showingPlaceholderAlert = true
      } label: {
        Image(systemName: "arrow.down.circle")
      }.tint(.red)
    }

    .contextMenu {
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
    .alert("Coming soon", isPresented: $showingPlaceholderAlert) {
      Button("OK", role: .cancel) {}
    }
  }
}

struct PostRowView_Previews: PreviewProvider {
  static var previews: some View {
    PostRowView(post: MockData.post).padding()
  }
}

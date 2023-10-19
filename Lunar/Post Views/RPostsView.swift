//
//  RPostsView.swift
//  Lunar
//
//  Created by Mani on 19/10/2023.
//

import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct RPostsView: View {
  @ObservedResults(RealmPost.self) var realmPosts

  var body: some View {
    List {
      ForEach(realmPosts, id: \.postID) { post in
        RPostItem(post: post)
      }
      .listRowBackground(Color("postListBackground"))
    }
    .background(Color("postListBackground"))
    .listStyle(.plain)
  }
}

struct RPostItem: View {
  var post: RealmPost

  let haptics = UIImpactFeedbackGenerator(style: .soft)
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

  var body: some View {
    ZStack {
      postBackground
      VStack(alignment: .leading, spacing: 5) {
        postImage
        postCommunityLabel
        postTitle
        postCreatorLabel
      }
      .padding(.horizontal)
      .padding(.vertical, 5)
      commentsNavLink
    }
    .listRowSeparator(.hidden)
    .padding(.vertical, 5)
    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
      Button {
        //              isClicked = true
      } label: {
        Image(systemSymbol: .chevronForwardCircleFill)
      }
      .foregroundStyle(.blue)
      .tint(Color("postListBackground"))
    }
    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      Button {
        //              isClicked = true
      } label: {
        Image(systemSymbol: .arrowUpCircleFill)
      }
      .tint(Color("postListBackground"))
      Button {
        //              isClicked = true
      } label: {
        Image(systemSymbol: .arrowDownCircleFill)
      }
      .tint(Color("postListBackground"))
    }
    .contextMenu {
      Button {
        // Add this item to a list of favorites.
      } label: {
        Label("Add to Favorites", systemImage: "heart")
      }
      Button {
        // Open Maps and center it on this item.
      } label: {
        Label("Show in Maps", systemImage: "mappin")
      }
      Button {
        // Open Maps and center it on this item.
      } label: {
        Label("Hide", systemImage: "eye.slash")
          .tint(.orange)
      }
    }
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
          haptics.impactOccurred(intensity: 0.5)
        }
      )
  }

  var postTitle: some View {
    Text(post.postName)
      .fontWeight(.semibold)
      .foregroundColor(.primary)
  }

  var postCreatorLabel: some View {
    Text(creatorLabel)
      .font(.caption)
      .foregroundColor(.secondary)
  }

  var commentsNavLink: some View {
    NavigationLink {
      PlaceholderView() // Comments View
    } label: {
      EmptyView()
    }
    .opacity(0)
  }
}

struct RPostsView_Previews: PreviewProvider {
  static var previews: some View {
    let samplePost = RealmPost(
      postID: 1,
      postName: "Sonoma",
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
      communityDescription: "This is a sample community description. It provides information about the community.",
      communityIcon: "https://example.com/community-icon.jpg",
      communityBanner: "https://example.com/community-banner.jpg",
      communityUpdated: "October 16, 2023",
      postScore: 42,
      postCommentCount: 10,
      upvotes: 30,
      downvotes: 12
    )
    return RPostItem(post: samplePost).previewLayout(.sizeThatFits)
  }
}

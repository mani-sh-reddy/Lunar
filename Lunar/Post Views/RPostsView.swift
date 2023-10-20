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

  @State var showSafari: Bool = false
  @State var upvoted: Bool = false
  @State var downvoted: Bool = false

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
      VStack(alignment: .leading, spacing: 7) {
        postImage
        HStack {
          postCommunityLabel
        }
        postTitle
        postCreatorLabel
        HStack(spacing: 15) {
          postUpvotes
          postDownvotes
          postComments
          Spacer()
          postWebLink
        }
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
      .tint(.blue)
    }
    .swipeActions(edge: .leading, allowsFullSwipe: false) {
      Button {
        //              isClicked = true
      } label: {
        Image(systemSymbol: .arrowUpCircleFill)
      }
      .tint(.orange)
      Button {
        //              isClicked = true
      } label: {
        Image(systemSymbol: .arrowDownCircleFill)
      }
      .tint(.purple)
    }
    .contextMenu {
      Button {} label: {
        Label("Add to Favorites", systemImage: "heart")
      }
      Button {} label: {
        Label("Show in Maps", systemImage: "mappin")
      }
      Button {} label: {
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
          hapticsLight.impactOccurred(intensity: 0.5)
        }
      )
  }

  @ViewBuilder
  var postWebLink: some View {
    if let url = post.postURL {
      HStack(spacing: 3) {
        Image(systemSymbol: .safari)
        Text(webLink)
      }
      .font(.caption)
      .textCase(.lowercase)
      .foregroundColor(.blue)
      .highPriorityGesture(
        TapGesture().onEnded {
          hapticsLight.impactOccurred(intensity: 0.5)
          showSafari.toggle()
        }
      )
      .inAppSafari(isPresented: $showSafari, stringURL: url)
    }
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

  var postUpvotes: some View {
    HStack {
      Image(systemSymbol: .arrowUpSquare)
      Text(String(post.upvotes ?? 0))
    }
    .lineLimit(1)
    .foregroundStyle(upvoted ? .white : .green)
    .padding(3)
    .background(upvoted ? .green : .gray.opacity(0.05))
    .symbolRenderingMode(upvoted ? .monochrome : .hierarchical)
    .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
    .highPriorityGesture(
      TapGesture().onEnded {
        upvoted.toggle()
        hapticsLight.impactOccurred()
      }
    )
  }

  @ViewBuilder
  var postDownvotes: some View {
    if let downvotes = post.downvotes {
      HStack {
        Image(systemSymbol: .arrowDownSquare)
        Text(String(downvotes))
      }
      .lineLimit(1)
      .foregroundStyle(downvoted ? .white : .red)
      .padding(3)
      .background(downvoted ? .red : .gray.opacity(0.05))
      .symbolRenderingMode(downvoted ? .monochrome : .hierarchical)
      .clipShape(RoundedRectangle(cornerRadius: 5.0, style: .continuous))
      .highPriorityGesture(
        TapGesture().onEnded {
          downvoted.toggle()
          hapticsLight.impactOccurred()
        }
      )
    }
  }

  var postComments: some View {
    HStack {
      Image(systemSymbol: .bubbleLeftAndBubbleRight)
      Text(String(post.downvotes ?? 0))
    }
    .lineLimit(1)
    .foregroundStyle(.gray)
    .padding(3)
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

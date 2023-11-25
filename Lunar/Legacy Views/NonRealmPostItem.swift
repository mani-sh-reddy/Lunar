//
//  NonRealmPostItem.swift
//  Lunar
//
//  Created by Mani on 24/10/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct NonRealmPostItem: View {
  var post: PostObject

  @State var showSafari: Bool = false

  var image: String? {
    let thumbnail = post.post.thumbnailURL ?? ""
    let url = post.post.url ?? ""
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
    let name = post.community.name
    let actorID = post.creator.actorID
    let instance = URLParser.extractDomain(from: actorID)
    if !actorID.isEmpty {
      return "\(name)@\(instance)"
    } else {
      return name
    }
  }

  var creatorTimeAgoLabel: String {
    let creator = post.creator.name.uppercased()
    let timeAgo = post.post.published
    if !timeAgo.isEmpty {
      return "\(creator), \(timeAgo) ago"
    } else {
      return "\(creator)"
    }
  }

  var webLink: String {
    let url = post.post.url ?? ""
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
        HStack(spacing: 5) {
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
  }

  var postTitle: some View {
    Text(post.post.name)
      .fontWeight(.semibold)
      .foregroundColor(.primary)
  }

  var postCreatorLabel: some View {
    Text(creatorTimeAgoLabel)
      .font(.caption)
      .foregroundColor(.secondary)
  }

  var postUpvotes: some View {
    PostButtonItem(
      text: String(post.counts.upvotes ?? 0),
      icon: .arrowUpCircleFill,
      color: Color.green,
      active: post.myVote == 1,
      opposite: false
    )
  }

  @ViewBuilder
  var postDownvotes: some View {
    if let downvotes = post.counts.downvotes {
      PostButtonItem(
        text: String(downvotes),
        icon: .arrowDownCircleFill,
        color: Color.red,
        active: post.myVote == -1,
        opposite: false
      )
    }
  }

  var postComments: some View {
    PostButtonItem(
      text: String(post.counts.comments ?? 0),
      icon: .bubbleLeftCircleFill,
      color: Color.gray
    )
  }

  @ViewBuilder
  var postWebLink: some View {
    if let url = post.post.url {
      if post.post.url != post.post.url {
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
      NonRealmCommentsView(
        commentsFetcher: CommentsFetcher(postID: post.post.id),
        post: post
      )
    } label: {
      EmptyView()
    }
    .opacity(0)
  }
}

//
//  RPostsViewLabel.swift
//  Lunar
//
//  Created by Mani on 18/10/2023.
//

import Foundation
import RealmSwift
import SwiftUI

struct RPostsViewLabel: View {
  var body: some View {
    HStack {
      LinearGradient(
        colors: [
          .yellow,
          .orange.opacity(0.8),
          .pink,
          .purple,
        ],
        startPoint: .top,
        endPoint: .bottom
      ).mask {
        Image(systemSymbol: .circleFill)
          .resizable()
          .frame(width: 30, height: 30)
      }
      .frame(width: 30, height: 30)
      Text("Realm Posts")
        .padding(.horizontal, 10)
    }
  }
}

// struct RealmPostsView: View {
//  @ObservedResults(RealmPost.self) var realmPosts
//
//  var body: some View {
//    List {
//      ForEach(realmPosts, id: \.id) { post in
//        Section {
//          RealmPostItemView(post: post)
//        }
//      }
//    }
//    .listStyle(.insetGrouped)
//    .navigationTitle("Realm DB Persisted Posts")
//    .navigationBarTitleDisplayMode(.inline)
//  }
// }
//
// struct RealmPostItemView: View {
//  let post: RealmPost
//
//  var body: some View {
//    VStack(alignment: .leading, spacing: 8) {
//      Text(post.postName)
//        .font(.headline)
//      Text(post.postPublished)
//        .font(.subheadline)
//        .foregroundColor(.gray)
//
//      if let postThumbnailURL = post.postThumbnailURL {
//        InPostThumbnailView(thumbnailURL: postThumbnailURL, imageRadius: 25)
//          .aspectRatio(contentMode: .fit)
//      }
//      Text("By \(post.personName)")
//        .font(.subheadline)
//        .foregroundColor(.blue)
//      Text(post.personPublished ?? "")
//        .font(.caption)
//        .foregroundColor(.gray)
//    }
////    .padding(12)
//  }
// }
//
// struct RealmPostItemView_Previews: PreviewProvider {
//  static var previews: some View {
//    let samplePost = RealmPost(
//      postID: 1,
//      postName: "Sonoma",
//      postPublished: "October 18, 2023",
//      postURL: "https://example.com/sample-post",
//      postBody: "This is the body of the sample post. It contains some information about the post.",
//      postThumbnailURL: "https://i.imgur.com/bgHfktp.jpeg",
//      personID: 1,
//      personName: "mani",
//      personPublished: "October 17, 2023",
//      personActorID: "mani01",
//      personInstanceID: 123,
//      personAvatar: "https://i.imgur.com/cflaISU.jpeg",
//      personDisplayName: "Mani",
//      personBio: "Just a sample user on this platform.",
//      personBanner: "",
//      communityID: 1,
//      communityName: "Sample Community",
//      communityTitle: "Welcome to the Sample Community",
//      communityActorID: "samplecommunity",
//      communityInstanceID: 456,
//      communityDescription: "This is a sample community description. It provides information about the community.",
//      communityIcon: "https://example.com/community-icon.jpg",
//      communityBanner: "https://example.com/community-banner.jpg",
//      communityUpdated: "October 16, 2023",
//      postScore: 42,
//      postCommentCount: 10,
//      upvotes: 30,
//      downvotes: 12
//    )
//    return RealmPostItemView(post: samplePost).previewLayout(.sizeThatFits)
//  }
// }

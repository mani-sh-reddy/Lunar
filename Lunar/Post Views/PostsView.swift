//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 19/10/2023.
//

import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct PostsView: View {
  /// Removes hidden posts
  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts

  var sort: String
  var type: String
  var user: Int?
  var communityID: Int?
  var personID: Int?

  var realmPostsFiltered: Results<RealmPost> {
    realmPosts.where { $0.sort == sort && $0.type == type && $0.communityID == communityID ?? 0 }
  }

  @State var runOnce: Bool = false

  var body: some View {
    List {
      /// Using the list retrieved from Realm
      /// This list is updated in the realm specific postfetcher
      ForEach(realmPostsFiltered) { post in
        PostItem(post: post)
      }
      .listRowBackground(Color("postListBackground"))
      if !runOnce {
        Rectangle()
          .foregroundStyle(.green)
          /// Detects when at the end of the list
          .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
              PostsFetcher(
                sort: sort,
                type: type,
                communityID: communityID
              ).loadContent()
            }
          }
      }
    }
    .background(Color("postListBackground"))
    .listStyle(.plain)
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        infoToolbar
      }
    }
    .onChange(of: realmPostsFiltered.count) { _ in
      runOnce = false
    }
  }

  var infoToolbar: some View {
    HStack(alignment: .lastTextBaseline) {
      VStack {
        Image(systemSymbol: .mailStack)
        Text(String(realmPostsFiltered.count))
          .fixedSize()
      }
      .padding(.trailing, 3)
      VStack {
        Image(systemSymbol: .number)
        Text("<?>")
          .fixedSize()
      }
    }
    .font(.caption)
  }
}

struct RPostsView_Previews: PreviewProvider {
  static var previews: some View {
    let samplePost = RealmPost(
      postID: 1,
      postName: "Sonoma. This is the body of the sample post. It contains some information about the post.",
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
      downvotes: 12,
      postMyVote: 1,
      postHidden: false,
      postMinimised: true,
      sort: "Active",
      type: "All"
    )
    return PostItem(post: samplePost).previewLayout(.sizeThatFits)
  }
}

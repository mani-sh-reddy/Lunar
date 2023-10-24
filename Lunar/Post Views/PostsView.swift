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

  /// Passed in the realmDataState
  /// the maxPage can be read and incremented
  @ObservedRealmObject var realmDataState: RealmDataState

  var sort: String
  var type: String
  var user: Int?
  var community: Int?
  var person: Int?

  var realmPostsFiltered: Results<RealmPost> {
    realmPosts.where {
      $0.sort == sort && $0.type == type
    }
  }

  var body: some View {
    List {
      /// Using the list retrieved from Realm
      /// This list is updated in the realm specific postfetcher
      ForEach(realmPostsFiltered) { post in
        PostItem(post: post)
      }
      .listRowBackground(Color("postListBackground"))
      Rectangle()
        .foregroundStyle(.gray)
        /// Detects when at the end of the list
        .onAppear {
          print("Reached end of scroll view")
          incrementRealmPageNumber()
          /// Runs postfetcher with the required sort and type
          /// This should be expanded in the future to support community/person specific
          /// As well as support passing in sort and type parameters from the feedview struct
          DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            PostsFetcher(
              sortParameter: sort,
              typeParameter: type,
              currentPage: realmDataState.maxPage
            ).loadContent()
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
        Text(String(realmDataState.maxPage))
          .fixedSize()
      }
    }
    .font(.caption)
  }

  /// Incrementing the page number inside the realm object.
  /// Need to thaw the frozen property first
  func incrementRealmPageNumber() {
    do {
      try Realm().write {
        guard let thawedDataState = realmDataState.thaw() else {
          print("Unable to thaw!")
          return
        }
        thawedDataState.maxPage += 1
        print("thawed")
      }
    } catch {
      print("Failed to save: \(error.localizedDescription)")
    }
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

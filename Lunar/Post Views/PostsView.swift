//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 19/10/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct PostsView: View {
  @Default(.debugModeEnabled) var debugModeEnabled

  @ObservedResults(RealmPost.self, where: ({ !$0.postHidden })) var realmPosts
  @ObservedResults(Batch.self) var batches

  var filteredPosts: [RealmPost]

  var sort: String
  var type: String
  var user: Int
  var communityID: Int
  var personID: Int
  var filterKey: String

  var heading: String
  var communityName: String?
  var communityActorID: String?

  @State var runOnce: Bool = false
  @State var page: Int = 1
  @State var showingCreatePostPopover: Bool = false

  let hapticsRigid = UIImpactFeedbackGenerator(style: .rigid)

  var body: some View {
    List {
      ForEach(filteredPosts) { post in
        PostItem(post: post)
      }
      .listRowBackground(Color("postListBackground"))
      if !runOnce {
        Rectangle()
          .foregroundStyle(.green)
          .onAppear { loadMorePostsOnAppearAction() }
      } else {
        SmallNavButton(
          systemSymbol: .handTapFill,
          text: "Load More Posts",
          color: .blue,
          symbolLocation: .left
        )
        .onTapGesture { loadMorePostsButtonAction() }
      }
    }
    .background(Color("postListBackground"))
    .listStyle(.plain)
    .navigationTitle(heading)
    .navigationBarTitleDisplayMode(.inline)
    .refreshable {
      let realm = try! Realm()
      try! realm.write {
        realm.deleteAll()
      }
      runOnce = false
    }
    .toolbar {
      ToolbarItemGroup(placement: .navigationBarTrailing) {
        if communityActorID != nil {
          createPostButton
        }
        if debugModeEnabled {
          infoToolbar
        }
      }
    }
    .popover(isPresented: $showingCreatePostPopover) {
      CreatePostPopoverView(
        communityID: communityID,
        communityName: communityName ?? "",
        communityActorID: communityActorID ?? ""
      )
    }
    //    .onChange(of: realmPosts.count) { _ in
    //      runOnce = false
    //    }
  }

  func loadMorePostsOnAppearAction() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        page: page,
        filterKey: filterKey
      ).loadContent()
      /// Setting the page number for the batch.
      page += 1
    }
    runOnce = true
  }

  func loadMorePostsButtonAction() {
    hapticsRigid.impactOccurred(intensity: 0.5)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      PostsFetcher(
        sort: sort,
        type: type,
        communityID: communityID,
        page: page,
        filterKey: filterKey
      ).loadContent()
      page += 1
    }
  }

  var createPostButton: some View {
    Button {
      showingCreatePostPopover = true
    } label: {
      Image(systemSymbol: .rectangleFillBadgePlus)
    }
  }

  var infoToolbar: some View {
    HStack(alignment: .lastTextBaseline) {
      VStack {
        Image(systemSymbol: .signpostRight)
        Text(String(filteredPosts.count))
          .fixedSize()
      }
      .padding(.trailing, 3)
      VStack {
        Image(systemSymbol: .doc)
        Text(String(page))
          .fixedSize()
      }
    }
    .font(.caption)
  }

  // Function to determine if a batch should be displayed based on criteria
  private func filterBatch(
    batch: Batch,
    sort: String,
    type: String,
    user: Int,
    communityID: Int,
    personID: Int
  ) -> Bool {
    let filterCriteria: Bool =
      batch.sort == sort && batch.type == type && batch.userUsed == user
        && batch.communityID == communityID && batch.personID == personID

    return filterCriteria
  }
}

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    let samplePost = RealmPost(
      postID: 1,
      postName:
      "Sonoma. This is the body of the sample post. It contains some information about the post.",
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
      communityDescription:
      "This is a sample community description. It provides information about the community.",
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
      type: "All",
      filterKey: "sortAndTypeOnly"
    )
    return PostItem(post: samplePost).previewLayout(.sizeThatFits)
  }
}

//
//  RealmBrowser.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Foundation
import RealmSwift
import SwiftUI

struct RealmBrowser: View {
  var body: some View {
    List {
      NavigationLink {
        RealmPostsDataView()
      } label: {
        Text("RealmPostsDataView")
      }
    }
  }
}

struct RealmPostsDataView: View {
  @ObservedResults(RealmPost.self) var realmPosts

  var body: some View {
    List {
      ForEach(realmPosts, id: \.postID) { item in
        DisclosureGroup {
          Text(String(describing: item.postName))
          Text(String(describing: item.postPublished))
          Text(String(describing: item.postURL))
          Text(String(describing: item.postBody))
          Text(String(describing: item.postThumbnailURL))
          Text(String(describing: item.personID))
          Text(String(describing: item.personName))
          Text(String(describing: item.personPublished))
          Text(String(describing: item.personActorID))
          Text(String(describing: item.personInstanceID))
          Text(String(describing: item.personAvatar))
          Text(String(describing: item.personDisplayName))
          Text(String(describing: item.personBio))
          Text(String(describing: item.personBanner))
          Text(String(describing: item.communityID))
          Text(String(describing: item.communityName))
          Text(String(describing: item.communityTitle))
          Text(String(describing: item.communityActorID))
          Text(String(describing: item.communityInstanceID))
          Text(String(describing: item.communityDescription))
          Text(String(describing: item.communityIcon))
          Text(String(describing: item.communityBanner))
          Text(String(describing: item.communityUpdated))
          Text(String(describing: item.postScore))
          Text(String(describing: item.postCommentCount))
          Text(String(describing: item.upvotes))
          Text(String(describing: item.downvotes))
          Text(String(describing: item.postMyVote))
          Text(String(describing: item.postHidden))
          Text(String(describing: item.postMinimised))
        } label: {
          Text(String(describing: item.postID))
        }
      }
    }
    .listStyle(.insetGrouped)
  }
}

#Preview {
  RealmBrowser()
}

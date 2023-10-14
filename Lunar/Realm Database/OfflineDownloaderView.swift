//
//  OfflineDownloaderView.swift
//  Lunar
//
//  Created by Mani on 22/09/2023.
//

import Defaults
import Foundation
import RealmSwift
import SFSafeSymbols
import SwiftUI

struct OfflineDownloaderView: View {
  @Default(.lastDownloadedPage) var lastDownloadedPage
  @ObservedResults(PersistedPostModel.self) var persistedPosts
  @ObservedResults(PersistedCommentsModel.self) var persistedComments

  let realm = try! Realm()
  let haptics = UIImpactFeedbackGenerator(style: .light)

  var body: some View {
    let persistedObjects = realm.objects(PersistedObject.self)
//    let persistedPosts = realm.objects(PersistedPostModel.self)
//    let persistedSpecificObject = persistedObjects.where {
//      $0.label == "ActiveAll"
//    }

    List {
      Text("Number of PersistedObjects: \(persistedObjects.count)")
      Text("Number of PersistedPosts: \(persistedPosts.count)")
      ForEach(persistedPosts, id: \.id) { post in
        NavigationLink {
          List {
            Section {
              Text(post.title)
              Text(post.postBody)
            }
            Section {
//              let offlineDownloader = OfflineDownloader(
//                sortParameter: "Active",
//                typeParameter: "All",
//                communityID: 0,
//                instance: nil,
//                postID: 0,
//                page: lastDownloadedPage
//              )
//              let getComments = offlineDownloader.loadComments(postID: post.id)
//              ForEach(getComments, id: \.self) { comment in
//                Text(comment.commentBody)
//                  .onAppear(){
//
//
//                  }
//              }
            }
          }
        } label: {
          Text(post.title)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          haptics.impactOccurred()
          let offlineDownloader = OfflineDownloader(
            sortParameter: "Active",
            typeParameter: "All",
            communityID: 0,
            instance: nil,
            postID: 0,
            page: lastDownloadedPage
          )
          offlineDownloader.loadPosts()
//          persistedPosts.map { post in
//            offlineDownloader.loadComments(postID: post.id)
//          }
          lastDownloadedPage += 1
        } label: {
          Image(systemSymbol: .arrowDownDocFill)
            .foregroundStyle(.green)
        }
      }
      ToolbarItem(placement: .topBarTrailing) {
        Button {
          haptics.impactOccurred()
          lastDownloadedPage = 1
          try! realm.write {
            realm.deleteAll()
          }
        } label: {
          Image(systemSymbol: .trashFill)
            .foregroundStyle(.red)
        }
      }
    }
  }
}

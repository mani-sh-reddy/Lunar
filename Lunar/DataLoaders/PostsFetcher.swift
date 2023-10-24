//
//  PostsFetcher.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Alamofire
import Combine
import Defaults
import Nuke
import Pulse
import RealmSwift
import SwiftUI

@MainActor class PostsFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.postSort) var postSort
  @Default(.postType) var postType
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.selectedInstance) var selectedInstance

  @Published var isLoading = false

  @State var numberOfPosts = 0

  let pulse = Pulse.LoggerStore.shared
  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  var currentPage: Int = 1
  var sortParameter: String?
  var typeParameter: String?
  var communityID: Int?
  var instance: String?

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      communityID: communityID,
      jwt: getJWTFromKeychain(),
      instance: instance
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: currentPage,
      limitParameter: 50,
      communityID: communityID,
      instance: instance
    ).buildURL()
  }

  init(
    sortParameter: String? = nil,
    typeParameter: String? = nil,
    communityID: Int? = 0,
    instance: String? = nil,
    currentPage: Int
  ) {
    if communityID == 99_999_999_999_999 { // TODO: just a placeholder to prevent running when user posts
      return
    }

    self.currentPage = currentPage

    self.sortParameter = sortParameter ?? postSort
    self.typeParameter = typeParameter ?? postType

    self.communityID = (communityID == 0) ? nil : communityID

    /// Can explicitly pass in an instance if it's different to the currently selected instance
    self.instance = instance

    loadContent()
  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)
    print("_____________FETCH_TRIGGERED_____________")
    AF.request(endpoint) { urlRequest in
      if isRefreshing {
        urlRequest.cachePolicy = .reloadRevalidatingCacheData
      } else {
        urlRequest.cachePolicy = .returnCacheDataElseLoad
      }
      urlRequest.networkServiceType = .responsiveData
    }
    .cacheResponse(using: cacher)
    .validate(statusCode: 200 ..< 300)
    .responseDecodable(of: PostModel.self) { response in
      if self.networkInspectorEnabled {
        self.pulse.storeRequest(
          try! URLRequest(url: self.endpointRedacted, method: .get),
          response: response.response,
          error: response.error,
          data: response.data
        )
      }

      switch response.result {
      case let .success(result):

        let imageRequestList = result.imageURLs.compactMap {
          ImageRequest(url: URL(string: $0), processors: [.resize(width: 200)])
        }
        self.imagePrefetcher.startPrefetching(with: imageRequestList)

        // MARK: - Realm

        /// Creating a realm post entry for each of the retreived posts
        /// and writing to the realm database
        let realm = try! Realm()
        try! realm.write {
          for post in result.posts {
            let fetchedPost = RealmPost(
              postID: post.post.id,
              postName: post.post.name,
              postPublished: post.post.published,
              postURL: post.post.url,
              postBody: post.post.body,
              postThumbnailURL: post.post.thumbnailURL,
              personID: post.creator.id,
              personName: post.creator.name,
              personPublished: post.creator.published,
              personActorID: post.creator.actorID,
              personInstanceID: post.creator.instanceID,
              personAvatar: post.creator.avatar,
              personDisplayName: post.creator.displayName,
              personBio: post.creator.bio,
              personBanner: post.creator.banner,
              communityID: post.community.id,
              communityName: post.community.name,
              communityTitle: post.community.title,
              communityActorID: post.community.actorID,
              communityInstanceID: post.community.instanceID,
              communityDescription: post.community.description,
              communityIcon: post.community.icon,
              communityBanner: post.community.banner,
              communityUpdated: post.community.updated,
              postScore: post.counts.postScore,
              postCommentCount: post.counts.commentCount,
              upvotes: post.counts.upvotes,
              downvotes: post.counts.downvotes,
              postMyVote: post.myVote ?? 0,
              postHidden: false,
              postMinimised: false,
              sort: self.sortParameter,
              type: self.typeParameter
            )
            realm.add(fetchedPost, update: .modified)
            self.numberOfPosts = realm.objects(RealmPost.self).count
          }
          /// This object holds the data about what batch of posts were fetched
          /// It saves the page number that the posts were fetched from so that duplicates are not fetched
          /// Creates a new table if it doesn't exist
          let realmDataState = RealmDataState(
            instance: self.instance ?? self.selectedInstance,
            sortParameter: self.sortParameter,
            typeParameter: self.typeParameter,
            numberOfPosts: self.numberOfPosts,
            maxPage: self.currentPage,
            latestTime: NSDate().timeIntervalSince1970, // is of type Double
            userUsed: self.activeAccount.actorID,
            communityID: nil,
            personID: nil
          )
          realm.add(realmDataState, update: .modified)
        }
        self.isLoading = false

      case let .failure(error):
        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
        self.isLoading = false
      }
    }
  }

  func getJWTFromKeychain() -> String? {
    if let keychainObject = KeychainHelper.standard.read(
      service: appBundleID, account: activeAccount.actorID
    ) {
      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
      return jwt.replacingOccurrences(of: "\"", with: "")
    } else {
      return nil
    }
  }
}

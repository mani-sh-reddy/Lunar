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

class PostsFetcher: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.selectedInstance) var selectedInstance

  @Published var isLoading = false

  let pulse = Pulse.LoggerStore.shared
  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)

  var sort: String
  var type: String
  var communityID: Int?
  var personID: Int?
  var instance: String?
  var filterKey: String
  var endpointPath: String
  //  var page: Int

  @State private var page: Int = 1

  private var endpoint: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      sortParameter: sort,
      typeParameter: type,
      currentPage: page,
      limitParameter: 50,
      communityID: communityID,
      personID: personID,
      jwt: getJWTFromKeychain(),
      instance: instance
    ).buildURL()
  }

  private var endpointRedacted: URLComponents {
    URLBuilder(
      endpointPath: endpointPath,
      sortParameter: sort,
      typeParameter: type,
      currentPage: page,
      limitParameter: 50,
      communityID: communityID,
      personID: personID,
      instance: instance
    ).buildURL()
  }

  init(
    sort: String,
    type: String,
    communityID: Int? = 0,
    personID: Int? = 0,
    instance: String? = nil,
    page: Int,
    filterKey: String
  ) {
    ///    When getting user specific posts, need to use a different endpoint path.
    if personID == nil || personID == 0 {
      endpointPath = "/api/v3/post/list"
    } else {
      endpointPath = "/api/v3/user"
    }

    self.page = page

    if communityID == 99_999_999_999_999 { // TODO: just a placeholder to prevent running when user posts
      self.communityID = 0
    }

    /// Values that can be passed in explicitly. Reverts to default if not passed in.
    self.sort = sort
    self.type = type

    /// Force an instance if it's different to the one you want
    self.instance = instance

    self.communityID = communityID
    self.personID = personID

    self.filterKey = filterKey
  }

  func loadContent(isRefreshing: Bool = false) {
    guard !isLoading else { return }

    isLoading = true

    let cacher = ResponseCacher(behavior: .cache)

    var headers: HTTPHeaders = []
    if let jwt = getJWTFromKeychain() {
      headers = [.authorization(bearerToken: jwt)]
    }

    print("_____________FETCH_TRIGGERED_____________")
    AF.request(endpoint, headers: headers) { urlRequest in
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

        ///    When getting user specific posts, look for

        let imageRequestList = result.imageURLs.compactMap {
          ImageRequest(url: URL(string: $0), processors: [.resize(width: 200)])
        }
        self.imagePrefetcher.startPrefetching(with: imageRequestList)

        // MARK: - Realm

        let realm = try! Realm()

        let batchID =
          "instance_\(self.instance ?? self.selectedInstance)" + "__sort_\(self.sort)"
            + "__type_\(self.type)" + "__userUsed_\(Int(self.activeAccount.userID) ?? 0)"
            + "__communityID_\(self.communityID ?? 0)" + "__personID_\(self.personID ?? 0)"

        let batch = Batch(
          batchID: batchID,
          instance: self.instance ?? self.selectedInstance,
          sort: self.sort,
          type: self.type,
          numberOfPosts: 0,
          page: self.page,
          latestTime: NSDate().timeIntervalSince1970,
          userUsed: Int(self.activeAccount.userID) ?? 0,
          communityID: self.communityID ?? 0,
          personID: self.personID ?? 0
        )

        try! realm.write {
          if let batch = realm.object(ofType: Batch.self, forPrimaryKey: batchID) {
            print("batch found")
            //           batch.realmPosts.append(objectsIn: realmPosts)
            batch.page = self.page
          } else {
            print("Batch not found with the primary key specified, creating new batch")
            realm.add(batch, update: .modified)
            //            batch.realmPosts.append(objectsIn: realmPosts)
          }

          for post in result.posts {
            let fetchedPost = RealmPost(
              postID: post.post.id,
              postName: post.post.name,
              postPublished: post.post.published,
              postURL: post.post.url,
              postBody: post.post.body,
              postThumbnailURL: post.post.thumbnailURL,
              postFeatured: post.post.featuredCommunity || post.post.featuredLocal,
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
              communitySubscribed: post.subscribed,
              postScore: post.counts.postScore,
              postCommentCount: post.counts.comments,
              upvotes: post.counts.upvotes,
              downvotes: post.counts.downvotes,
              postMyVote: post.myVote ?? 0,
              postHidden: false,
              postMinimised: post.post.featuredCommunity || post.post.featuredLocal,
              sort: self.sort,
              type: self.type,
              filterKey: self.filterKey
            )
            realm.add(fetchedPost, update: .modified)
            //            batch.realmPosts.append(fetchedPost)
          }
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

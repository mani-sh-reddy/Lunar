////
////  PostsFetcher.swift
////  Lunar
////
////  Created by Mani on 23/07/2023.
////
//
// import Alamofire
// import Combine
// import Defaults
// import Nuke
// import Pulse
// import RealmSwift
// import SwiftUI
//
// @MainActor class old_PostsFetcher: ObservableObject {
//  @Default(.activeAccount) var activeAccount
//  @Default(.appBundleID) var appBundleID
//  @Default(.postSort) var postSort
//  @Default(.postType) var postType
//  @Default(.networkInspectorEnabled) var networkInspectorEnabled
//
//  @Published var posts = [PostObject]()
//  @Published var isLoading = false
//
//  let pulse = Pulse.LoggerStore.shared
////  let imageRequest = ImageRequest(url: URL(string: thumbnailURL), processors: [.resize(width: 250)])
//  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)
//
//  private var currentPage = 1
//  var sortParameter: String?
//  private var typeParameter: String?
//  private var communityID: Int?
//  private var instance: String?
//
//  private var endpoint: URLComponents {
//    URLBuilder(
//      endpointPath: "/api/v3/post/list",
//      sortParameter: sortParameter,
//      typeParameter: typeParameter,
//      currentPage: currentPage,
//      limitParameter: 50,
//      communityID: communityID,
//      jwt: getJWTFromKeychain(),
//      instance: instance
//    ).buildURL()
//  }
//
//  private var endpointRedacted: URLComponents {
//    URLBuilder(
//      endpointPath: "/api/v3/post/list",
//      sortParameter: sortParameter,
//      typeParameter: typeParameter,
//      currentPage: currentPage,
//      limitParameter: 50,
//      communityID: communityID,
//      instance: instance
//    ).buildURL()
//  }
//
//  init(
//    sortParameter: String? = nil,
//    typeParameter: String? = nil,
//    communityID: Int? = 0,
//    instance: String? = nil
//  ) {
//    if communityID == 99_999_999_999_999 { // TODO: just a placeholder to prevent running when user posts
//      return
//    }
//
//    self.sortParameter = sortParameter ?? postSort
//    self.typeParameter = typeParameter ?? postType
//
//    self.communityID = (communityID == 0) ? nil : communityID
//
//    /// Can explicitly pass in an instance if it's different to the currently selected instance
//    self.instance = instance
//
//    loadContent()
//  }
//
//  func loadMoreContentIfNeeded(currentItem: PostObject) {
//    guard currentItem.post.id == posts.last?.post.id else {
//      return
//    }
//    loadContent()
//  }
//
//  func loadContent(isRefreshing: Bool = false) {
//    guard !isLoading else { return }
//
//    if isRefreshing {
//      currentPage = 1
//    } else {
//      isLoading = true
//    }
//
//    let cacher = ResponseCacher(behavior: .cache)
//
//    AF.request(endpoint) { urlRequest in
//      if isRefreshing {
//        urlRequest.cachePolicy = .reloadRevalidatingCacheData
//      } else {
//        urlRequest.cachePolicy = .returnCacheDataElseLoad
//      }
//      urlRequest.networkServiceType = .responsiveData
//    }
//    .cacheResponse(using: cacher)
//    .validate(statusCode: 200 ..< 300)
//    .responseDecodable(of: PostModel.self) { response in
//      if self.networkInspectorEnabled {
//        self.pulse.storeRequest(
//          try! URLRequest(url: self.endpointRedacted, method: .get),
//          response: response.response,
//          error: response.error,
//          data: response.data
//        )
//      }
//
//      switch response.result {
//      case let .success(result):
//
//        // MARK: - Realm
//
//        let realm = try! Realm()
//        try! realm.write {
//          for post in result.posts {
//            let fetchedPost = RealmPost(
//              postID: post.post.id,
//              postName: post.post.name,
//              postPublished: post.post.published,
//              postURL: post.post.url,
//              postBody: post.post.body,
//              postThumbnailURL: post.post.thumbnailURL,
//              personID: post.creator.id,
//              personName: post.creator.name,
//              personPublished: post.creator.published,
//              personActorID: post.creator.actorID,
//              personInstanceID: post.creator.instanceID,
//              personAvatar: post.creator.avatar,
//              personDisplayName: post.creator.displayName,
//              personBio: post.creator.bio,
//              personBanner: post.creator.banner,
//              communityID: post.community.id,
//              communityName: post.community.name,
//              communityTitle: post.community.title,
//              communityActorID: post.community.actorID,
//              communityInstanceID: post.community.instanceID,
//              communityDescription: post.community.description,
//              communityIcon: post.community.icon,
//              communityBanner: post.community.banner,
//              communityUpdated: post.community.updated,
//              postScore: post.counts.postScore,
//              postCommentCount: post.counts.commentCount,
//              upvotes: post.counts.upvotes,
//              downvotes: post.counts.downvotes,
//              postMyVote: post.myVote ?? 0,
//              postHidden: false,
//              postMinimised: false
//            )
//            realm.add(fetchedPost, update: .modified)
//          }
//        }
//
//        // MARK: - General
//
//        let fetchedPosts = result.posts
//
//        let imageRequestList = result.imageURLs.compactMap {
//          ImageRequest(url: URL(string: $0), processors: [.resize(width: 200)])
//        }
//        self.imagePrefetcher.startPrefetching(with: imageRequestList)
//
////        let imagesToPrefetch = result.imageURLs.compactMap { URL(string: $0) }
////        self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)
//
//        if isRefreshing {
//          self.posts = fetchedPosts
//        } else {
//          /// Removing duplicates
//          let filteredPosts = fetchedPosts.filter { post in
//            !self.posts.contains { $0.post.id == post.post.id }
//          }
//          self.posts += filteredPosts
//          self.currentPage += 1
//        }
//        if !isRefreshing {
//          self.isLoading = false
//        }
//      case let .failure(error):
//        print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
//        if !isRefreshing {
//          self.isLoading = false
//        }
//      }
//    }
//  }
//
//  func getJWTFromKeychain() -> String? {
//    if let keychainObject = KeychainHelper.standard.read(
//      service: appBundleID, account: activeAccount.actorID
//    ) {
//      let jwt = String(data: keychainObject, encoding: .utf8) ?? ""
//      return jwt.replacingOccurrences(of: "\"", with: "")
//    } else {
//      return nil
//    }
//  }
// }

//
//  OfflineDownloader.swift
//  Lunar
//
//  Created by Mani on 22/09/2023.
//

import Alamofire
import Defaults
import Foundation
import Nuke
import Pulse
import RealmSwift

@MainActor class OfflineDownloader: ObservableObject {
  @Default(.selectedActorID) var selectedActorID
  @Default(.appBundleID) var appBundleID
  @Default(.postSort) var postSort
  @Default(.postType) var postType
  @Default(.networkInspectorEnabled) var networkInspectorEnabled
  @Default(.commentSort) var commentSort
  @Default(.commentType) var commentType
  @Default(.lastDownloadedPage) var lastDownloadedPage

  @Published var posts = [PostObject]()
  @Published var comments = [CommentObject]()
  @Published var isLoading = false

  let pulse = Pulse.LoggerStore.shared
  let imagePrefetcher = ImagePrefetcher(pipeline: ImagePipeline.shared)
  let realm = try! Realm()

  var sortParameter: String?
  var typeParameter: String?
  private var communityID: Int?
  private var instance: String?
  var page: Int = 1

  var postID: Int?

  private var postsEndpoint: URLComponents {
    URLBuilder(
      endpointPath: "/api/v3/post/list",
      sortParameter: sortParameter,
      typeParameter: typeParameter,
      currentPage: page,
      limitParameter: 50,
      communityID: communityID,
      instance: instance
    ).buildURL()
  }

  init(
    sortParameter: String,
    typeParameter: String,
    communityID: Int? = 0,
    instance: String? = nil,
    postID: Int,
    page: Int
  ) {
    if communityID == 99_999_999_999_999 { return }
    self.sortParameter = sortParameter
    self.typeParameter = typeParameter
    self.communityID = (communityID == 0) ? nil : communityID
    self.instance = instance
    self.postID = postID
    self.page = page
    loadPosts()
  }

  func loadPosts() {
    guard !isLoading else { return }
    isLoading = true

    AF.request(postsEndpoint)
      .validate(statusCode: 200 ..< 300)
      .responseDecodable(of: PostModel.self) { response in
        if self.networkInspectorEnabled {
          self.pulse.storeRequest(
            try! URLRequest(url: self.postsEndpoint, method: .get),
            response: response.response,
            error: response.error,
            data: response.data
          )
        }

        switch response.result {
        case let .success(result):

          let fetchedPosts = result.posts

          let imagesToPrefetch = result.imageURLs.compactMap { URL(string: $0) }
          self.imagePrefetcher.startPrefetching(with: imagesToPrefetch)

          /// Removing duplicates
          let filteredPosts = fetchedPosts.filter { post in
            !self.posts.contains { $0.post.id == post.post.id }
          }
          self.posts += filteredPosts

          let existingPrimaryKeys = Set(self.realm.objects(PersistedPostModel.self).map(\.id))

          let persistedPosts = filteredPosts
            .filter { !existingPrimaryKeys.contains($0.post.id) }
            .map { post in
              PersistedPostModel(
                id: post.post.id,
                title: post.post.name,
                postPublished: post.post.published,
                url: post.post.url ?? "",
                postBody: post.post.body ?? "",
                thumbnailURL: post.post.thumbnailURL ?? "",
                postUpvotes: post.counts.upvotes ?? 0,
                postDownvotes: post.counts.downvotes ?? 0,
                numberOfComments: post.counts.comments ?? 0,
                instance: post.post.apID,
                communityName: post.community.name
              )
            }

          let label = "\(self.sortParameter ?? "")\(self.typeParameter ?? "")"

          if let existingObject = self.realm.objects(PersistedObject.self).filter("label == %@", label).first {
            try! self.realm.write {
              existingObject.posts.append(objectsIn: persistedPosts)
            }
          } else {
            try! self.realm.write {
              let postsList = List<PersistedPostModel>()
              postsList.append(objectsIn: persistedPosts)

              let persistedObject = PersistedObject(
                label: label,
                posts: postsList
              )
              self.realm.add(persistedObject, update: .modified)
            }
          }

          self.isLoading = false

        case let .failure(error):
          print("PostsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
          self.isLoading = false
        }
      }
  }

  func persistComments(_ comments: [CommentObject]) -> List<PersistedCommentsModel> {
    let commentsList = List<PersistedCommentsModel>()
    let persistedComments = comments.map { comment in
      PersistedCommentsModel(
        postID: comment.post.id, // using the post id as the primary key
        commentBody: comment.comment.content,
        commentPublished: comment.comment.published,
        commentCreatorName: comment.creator.name,
        commentUpvotes: comment.counts.upvotes ?? 0,
        commentDownvotes: comment.counts.downvotes ?? 0
      )
    }
    commentsList.append(objectsIn: persistedComments)
    return commentsList
  }

  func loadComments(postID: Int) {
    var commentsEndpoint: URLComponents {
      URLBuilder(
        endpointPath: "/api/v3/comment/list",
        sortParameter: commentSort,
        typeParameter: commentType,
        currentPage: 1,
        limitParameter: 50,
        postID: postID,
        maxDepth: 50
      ).buildURL()
    }

    guard !isLoading else { return }
    isLoading = true

    AF.request(commentsEndpoint)
      .validate(statusCode: 200 ..< 300)
      .responseDecodable(of: CommentModel.self) { response in

        if self.networkInspectorEnabled {
          self.pulse.storeRequest(
            try! URLRequest(url: commentsEndpoint, method: .get),
            response: response.response,
            error: response.error,
            data: response.data
          )
        }

        switch response.result {
        case let .success(result):
          let newComments = result.comments

          let filteredNewComments = newComments.filter { newComments in
            !self.comments.contains { $0.comment.id == newComments.comment.id }
          }

          if !filteredNewComments.isEmpty {
            DispatchQueue.main.sync {
              let sortedFilteredComments = filteredNewComments.sorted { sorted, newSorted in
                sorted.comment.path < newSorted.comment.path
              }
              for newComment in sortedFilteredComments {
                InsertSorter.sortComments(newComment, into: &self.comments)
              }

              self.isLoading = false
            }
          } else {
            self.isLoading = false
          }

        case let .failure(error):
          print("CommentsFetcher ERROR: \(error): \(error.errorDescription ?? "")")
          self.isLoading = false
        }
      }
  }
}

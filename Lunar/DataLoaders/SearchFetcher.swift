//
//  SearchFetcher.swift
//  Lunar
//
//  Created by Mani on 04/08/2023.
//

import Alamofire
import Combine
import Foundation
import Kingfisher
import SwiftUI

@MainActor class SearchFetcher: ObservableObject {
    @Published var searchModel = [SearchModel]()

    @Published var comments = [SearchCommentElement]()
    @Published var communities = [SearchCommunityElement]()
    @Published var posts = [SearchPostElement]()
    @Published var users = [SearchUserElement]()

    @Published var isLoading = false

    var searchQuery: String

    ///  Clear the current search list when making a new search
    ///  Defaults to false but will be set by the view
    var clearListOnChange: Bool

    private var currentPage = 1
    var typeParameter: String
    private var limitParameter: Int = 5
    private var endpoint: URLComponents {
        URLBuilder(
            endpointPath: "/api/v3/search",
            typeParameter: typeParameter,
            currentPage: currentPage,
            limitParameter: limitParameter,
            searchQuery: searchQuery
        ).buildURL()
    }

    init(
        searchQuery: String,
        typeParameter: String,
        limitParameter: Int,
        clearListOnChange: Bool
    ) {
        self.searchQuery = searchQuery
        self.typeParameter = typeParameter
        self.limitParameter = limitParameter
        self.clearListOnChange = clearListOnChange
        loadMoreContent()
    }

    ///    func refreshContent() async {
//        do {
//            try await Task.sleep(nanoseconds: 1_000_000_000)
//        } catch {}
//
//        guard !isLoading else { return }
//
//        isLoading = true
//        currentPage = 1
//
//        let cacher = ResponseCacher(behavior: .cache)
//
//        AF.request(endpoint) { urlRequest in
//            print("SearchFetcher REF \(urlRequest.url as Any)")
//            urlRequest.cachePolicy = .returnCacheDataElseLoad
//        }
//        .cacheResponse(using: cacher)
//        .validate(statusCode: 200 ..< 300)
//        .responseDecodable(of: SearchModel.self) { response in
//            switch response.result {
//            case let .success(result):
//                // Check the typeParameter to determine which part of the code to execute
//                switch self.typeParameter {
//                case "communities":
//                    let newCommunities = result.communities
//                    let filteredNewCommunities = newCommunities.filter { newCommunity in
//                        !self.communities.contains { $0.community.id == newCommunity.community.id }
//                    }
//                    self.communities.insert(contentsOf: filteredNewCommunities, at: 0)
//                case "comments":
//                    let newComments = result.comments
//                    let filteredNewComments = newComments.filter { newComment in
//                        !self.comments.contains { $0.comment.id == newComment.comment.id }
//                    }
//                    self.comments.insert(contentsOf: filteredNewComments, at: 0)
//                case "posts":
//                    let newPosts = result.posts
//                    let filteredNewPosts = newPosts.filter { newPost in
//                        !self.posts.contains { $0.post.id == newPost.post.id }
//                    }
//                    self.posts.insert(contentsOf: filteredNewPosts, at: 0)
//                case "users":
//                    let newUsers = result.users
//                    let filteredNewUsers = newUsers.filter { newUser in
//                        !self.users.contains { $0.person.id == newUser.person.id }
//                    }
//                    self.users.insert(contentsOf: filteredNewUsers, at: 0)
//                default:
//                    return
//                }
//
//                self.isLoading = false
//            case let .failure(error):
//                print("SearchFetcher ERROR: \(error): \(error.errorDescription ?? "")")
//            }
//        }
//    }

    func loadMoreCommentIfNeeded(currentItem comment: SearchCommentElement?) {
        guard let comment else {
            loadMoreContent()
            return
        }
        let thresholdIndex = comments.index(comments.endIndex, offsetBy: -1)
        if comments.firstIndex(where: { $0.comment.id == comment.comment.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMoreCommunitiesIfNeeded(currentItem community: SearchCommunityElement?) {
        guard let community else {
            loadMoreContent()
            return
        }
        let thresholdIndex = communities.index(communities.endIndex, offsetBy: -1)
        if communities.firstIndex(where: { $0.community.id == community.community.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMorePostsIfNeeded(currentItem post: SearchPostElement?) {
        guard let post else {
            loadMoreContent()
            return
        }
        let thresholdIndex = posts.index(posts.endIndex, offsetBy: -1)
        if posts.firstIndex(where: { $0.post.id == post.post.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMoreUsersIfNeeded(currentItem user: SearchUserElement?) {
        guard let user else {
            loadMoreContent()
            return
        }
        let thresholdIndex = users.index(users.endIndex, offsetBy: -1)
        if users.firstIndex(where: { $0.person.id == user.person.id }) == thresholdIndex {
            loadMoreContent()
        }
    }

    func loadMoreContent() {
        guard !isLoading else { return }

        if clearListOnChange {
            comments.removeAll()
            communities.removeAll()
            posts.removeAll()
            users.removeAll()
        }

        print("SEARCH QUERY: \(searchQuery)")
        guard searchQuery != "" else {
            print("SEARCH QUERY EMPTY, RETURNING")
            return
        }

        isLoading = true

        let cacher = ResponseCacher(behavior: .cache)

        AF.request(endpoint) { urlRequest in
            print("SearchFetcher LOAD \(urlRequest.url as Any)")
            urlRequest.cachePolicy = .returnCacheDataElseLoad
        }
        .cacheResponse(using: cacher)
        .validate(statusCode: 200 ..< 300)
        .responseDecodable(of: SearchModel.self) { response in
            switch response.result {
            case let .success(result):
                // Check the typeParameter to determine which part of the code to execute
                switch self.typeParameter {
                case "Communities":
                    let newCommunities = result.communities
                    let filteredNewCommunities = newCommunities.filter { newCommunity in
                        !self.communities.contains { $0.community.id == newCommunity.community.id }
                    }
                    self.communities += filteredNewCommunities
                case "Comments":
                    let newComments = result.comments
                    let filteredNewComments = newComments.filter { newComment in
                        !self.comments.contains { $0.comment.id == newComment.comment.id }
                    }
                    self.comments += filteredNewComments
                case "Posts":
                    let newPosts = result.posts
                    let filteredNewPosts = newPosts.filter { newPost in
                        !self.posts.contains { $0.post.id == newPost.post.id }
                    }
                    self.posts += filteredNewPosts
                case "Users":
                    let newUsers = result.users
                    let filteredNewUsers = newUsers.filter { newUser in
                        !self.users.contains { $0.person.id == newUser.person.id }
                    }
                    self.users += filteredNewUsers
                default:
                    print("break")
                }

                self.isLoading = false
                self.currentPage += 1

            case let .failure(error):
                print("SearchFetcher ERROR: \(error): \(error.errorDescription ?? "")")
                self.isLoading = false // Set isLoading to false on failure as well
            }
        }
    }
}

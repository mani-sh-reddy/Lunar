////
////  PostsViewModel.swift
////  Lunar
////
////  Created by Mani on 25/10/2023.
////
//
// import Foundation
// import Combine
//
// class PostsViewModel: ObservableObject {
//  private var postsFetcher: PostsFetcher
//
//  @Published var posts: [RealmPost] = []
//  @Published var isLoading = false
//
//  init() {
//    // Initialize the PostsFetcher with default parameters or customize them as needed.
//    self.postsFetcher = PostsFetcher()
//  }
//
//  func loadPosts(isRefreshing: Bool = false) {
//    isLoading = true
//
//    postsFetcher.loadContent(isRefreshing: isRefreshing)
//
//    // You can observe the isLoading property from PostsFetcher to update the ViewModel's isLoading property.
//    postsFetcher.$isLoading
//      .sink { [weak self] isLoading in
//        self?.isLoading = isLoading
//      }
//      .store(in: &cancellables)
//
//    // You can also observe the posts fetched by PostsFetcher and update the ViewModel's posts property.
//    postsFetcher.$fetchedPosts
//      .sink { [weak self] fetchedPosts in
//        self?.posts = fetchedPosts
//      }
//      .store(in: &cancellables)
//  }
//
//  func refreshPosts() {
//    loadPosts(isRefreshing: true)
//  }
//
//  // You can add more functions and properties here to interact with the fetched posts or handle other operations as needed.
//
//  private var cancellables = Set<AnyCancellable>()
// }

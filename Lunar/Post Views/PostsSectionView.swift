////
////  PostsSectionView.swift
////  Lunar
////
////  Created by Mani on 06/09/2023.
////
//
// import Foundation
// import SwiftUI
//
// struct PostSectionView: View {
//  @State var upvoted: Bool = false
//  @State var downvoted: Bool = false
//
//  var post: RealmPost
//
//  var communityIsSubscribed: Bool {
//    post.subscribed == .subscribed
//  }
//
//  var body: some View {
//    Section {
//      ZStack {
//        PostRowView(
//          upvoted: $upvoted,
//          downvoted: $downvoted,
//          isSubscribed: communityIsSubscribed, post: post
//        )
//        NavigationLink {
//          CommentsView(
//            commentsFetcher: CommentsFetcher(postID: post.post.id),
//            upvoted: $upvoted,
//            downvoted: $downvoted,
//            post: post
//          )
//        } label: {
//          EmptyView()
//        }
//        .opacity(0)
//      }
//    }
//  }
// }

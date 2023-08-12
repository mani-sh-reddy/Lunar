//
//  PostsView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Kingfisher
import SwiftUI

//struct KbinThreadsView: View {
//  @AppStorage("kbinHostURL") var kbinHostURL = Settings.kbinHostURL
//  @StateObject var kbinThreadsFetcher: KbinThreadsFetcher
//  
//  @State var postURL: String = ""
//  
//  var body: some View {
//    List {
//      if kbinThreadsFetcher.isLoading {
//        ProgressView().id(UUID())
//      } else {
//        ForEach(kbinThreadsFetcher.posts, id: \.id) { post in
//          Section {
//            ZStack {
//              KbinPostRowView(post: post)
//              NavigationLink {
//                KbinCommentsView(post: post, postURL: "https://\(kbinHostURL)\(post.postURL)")
//              } label: {
//                EmptyView()
//              }
//              .opacity(0)
//            }
//          }
//          .task {
//            kbinThreadsFetcher.loadMoreContentIfNeeded(currentItem: post)
//            postURL = post.postURL
//          }
//        }
//      }
//    }
//    .refreshable {
//      await kbinThreadsFetcher.refreshContent()
//    }
//    .navigationTitle("Kbin")
//    .navigationBarTitleDisplayMode(.inline)
//    .listStyle(.insetGrouped)
//  }
//}

struct PostsView: View {
  @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
  @StateObject var postsFetcher: PostsFetcher
  
  var title: String
  
  var body: some View {
    List {
        ForEach(postsFetcher.posts, id: \.post.id) { post in
          Section {
            ZStack {
              PostRowView(post: post)
              NavigationLink {
                CommentsView(post: post)
              } label: {
                EmptyView()
              }
              .opacity(0)
            }
            .task {
              postsFetcher.loadMoreContentIfNeeded(currentItem: post)
            }
          }
        }
      if postsFetcher.isLoading {
        ProgressView().id(UUID())
      }
    }
    .refreshable {
      await postsFetcher.refreshContent()
    }
    .navigationTitle(title)
    .navigationBarTitleDisplayMode(.inline)
    .listStyle(.insetGrouped)
  }
}

    
//    ScrollViewReader { _ in
//      List {
//        ForEach(postsFetcher.posts, id: \.post.id) { post in
//          Section {
//            ZStack {
//              PostRowView(post: post)
//              NavigationLink(
//                destination: CommentsView(
//                  commentsFetcher: CommentsFetcher(
//                    postID: post.post.id,
//                    sortParameter: "Top",
//                    typeParameter: "All"
//                  ),
//                  postID: post.post.id,
//                  postTitle: post.post.name,
//                  thumbnailURL: post.post.thumbnailURL,
//                  postBody: post.post.body
//                )
//              ) {
//                EmptyView()
//                  .frame(height: 0)
//              }
//              .opacity(0)
//            }
//            .task {
//              postsFetcher.loadMoreContentIfNeeded(currentItem: post)
//            }
//            .accentColor(Color.primary)
//          }
//        }
//        if postsFetcher.isLoading {
//          ProgressView()
//        }
//      }
//      .navigationTitle(title)
//      .navigationBarTitleDisplayMode(.inline)
//      .listStyle(.grouped)
//      .refreshable {
//        await postsFetcher.refreshContent()
//      }
//    }
//    .onChange(of: instanceHostURL) { _ in
//      Task {
//        await postsFetcher.refreshContent()
//      }
//    }
//  }
//}

struct PostsView_Previews: PreviewProvider {
  static var previews: some View {
    /// need to set showing popover to a constant value
    PostsView(postsFetcher: PostsFetcher(
      sortParameter: "Hot",
      typeParameter: "All"
    ), title: "Title"
    )
  }
}

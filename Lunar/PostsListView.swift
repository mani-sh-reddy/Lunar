//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct PostsListView: View {
    @ObservedObject var allPosts = AllPostsListLoader()
    var feedType: String
    
    var body: some View {
        
        List {
            ForEach(allPosts.posts, id: \.post.id) { post in
                NavigationLink {
                    PlaceholderView()
                } label: {    
                    PostRowView(post: post)
                }
            }
        }.navigationTitle(feedType)
            .listStyle(.plain)
    }
}



struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView(feedType: "")
    }
}

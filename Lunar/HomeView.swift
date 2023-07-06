//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var trendingCommunities = LoadTrendingCommunities()
    
    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Feed")) {
                    FeedTypeRowView(feedType: "Local", icon: "house", iconColor: Color.green)
                    FeedTypeRowView(feedType: "All", icon: "globe.americas", iconColor: Color.cyan)
                }
                Section(header: Text("Trending")) {
                    ForEach(trendingCommunities.communities , id: \.community.id) { communities in
                        Text(communities.community.title)
                    }
                }
                Section(header: Text("Subscribed")) {
                    Text("Login to view subscribed communities")
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Communities")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var trendingCommunities = TrendingCommunitiesLoader()
    
    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Feed")) {
                    NavigationLink {
                        PostsListView(feedType: "Local")
                    } label: {
                        FeedTypeRowView(feedType: "Local", icon: "house.circle.fill", iconColor: Color.green)
                    }
                    NavigationLink {
                        PlaceholderView()
                    } label: {
                        FeedTypeRowView(feedType: "All", icon: "building.2.crop.circle.fill", iconColor: Color.cyan)
                    }
                    
                }
                Section(header: Text("Trending")) {
                    
                    ForEach(trendingCommunities.communities, id: \.community.id) { communities in
                        NavigationLink {
                            CommunityInfoView(community: communities.community)
                        } label: {
                            CommunityRowView(community: communities.community, counts: communities.counts)
                        }
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

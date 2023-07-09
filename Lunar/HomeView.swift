//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct HomeView: View {
    @StateObject private var trendingCommunitiesFetcher = Fetcher<CommunityModel>()
    @State var communityModel = CommunityModel(communities: [])

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feed")) {
                    NavigationLink { PostsListView(viewTitle: "Local", feedType: "Local", feedSort: "Active")
                    } label: {
                        FeedTypeRowView(feedType: "Local", icon: "house.circle.fill", iconColor: Color.green)
                    }
                    NavigationLink { PostsListView(viewTitle: "All", feedType: "All", feedSort: "Active")
                    } label: {
                        FeedTypeRowView(feedType: "All", icon: "building.2.crop.circle.fill", iconColor: Color.cyan)
                    }
                    NavigationLink { PostsListView(viewTitle: "Top", feedType: "All", feedSort: "TopWeek")
                    } label: {
                        FeedTypeRowView(feedType: "Top", icon: "chart.line.uptrend.xyaxis.circle.fill", iconColor: Color.pink)
                    }
                    NavigationLink { PostsListView(viewTitle: "New", feedType: "All", feedSort: "New")
                    } label: {
                        FeedTypeRowView(feedType: "New", icon: "star.circle.fill", iconColor: Color.yellow)
                    }
                }
                Section(header: Text("Trending")) {
                    ForEach(trendingCommunitiesFetcher.result?.communities ?? [], id: \.community.id) { communities in
                        NavigationLink {
                            PostsListView(viewTitle: communities.community.name, feedSort: "Active", communityId: communities.community.id)
                        } label: {
                            CommunityRowView(community: communities)
                        }
                    }
                }
                Section(header: Text("Subscribed")) {
                    Text("Login to view subscribed communities")
                }
            }
            .onAppear {
                fetchTrendingCommunities()
            }
            .listStyle(.grouped)
            .navigationTitle("Communities")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    func fetchTrendingCommunities() {
        let urlString = "https://lemmy.world/api/v3/community/list?sort=New&limit=50"
        trendingCommunitiesFetcher.fetchResponse(urlString: urlString)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

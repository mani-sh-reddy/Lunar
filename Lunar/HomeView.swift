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
                    NavigationLink { PostsListView(feedType: "Local", feedSort: "Active")
                    } label: {
                        FeedTypeRowView(feedType: "Local", icon: "house.circle.fill", iconColor: Color.green)
                    }
                    NavigationLink { PostsListView(feedType: "All", feedSort: "Active")
                    } label: {
                        FeedTypeRowView(feedType: "All", icon: "building.2.crop.circle.fill", iconColor: Color.cyan)
                    }
                    NavigationLink { PostsListView(feedType: "All", feedSort: "TopWeek")
                    } label: {
                        FeedTypeRowView(feedType: "Top", icon: "chart.line.uptrend.xyaxis.circle.fill", iconColor: Color.pink)
                    }
                    NavigationLink { PostsListView(feedType: "All", feedSort: "New")
                    } label: {
                        FeedTypeRowView(feedType: "New", icon: "star.circle.fill", iconColor: Color.yellow)
                    }
                }
                Section(header: Text("Trending")) {
                    ForEach(trendingCommunitiesFetcher.result?.communities ?? [], id: \.community.id) { communities in
                        NavigationLink {
                            CommunityInfoView(community: communities.community)
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
        let iconURLs = communityModel.iconURLs.compactMap { URL(string: $0) }
        let prefetcher = ImagePrefetcher(urls: iconURLs) {
            _, _, _ in
        }
        prefetcher.start()

        let urlString = "https://lemmy.world/api/v3/community/list?sort=Hot&limit=5"
        trendingCommunitiesFetcher.fetchResponse(urlString: urlString)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

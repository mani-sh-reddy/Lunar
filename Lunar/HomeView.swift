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
    @StateObject var communities = CommunitiesListFetcher()
    @State private var hasAppearedOnce = false

    var body: some View {
        NavigationView {
            List {
                groupedCommunitiesSection()
                Group {
                    if !communities.isLoaded {
                        Section(header: Text("Trending")) {
                            HStack {
                                ProgressView()
                                Text("Loading Trending Communities").opacity(0.5).padding(.horizontal, 3)
                            }
                        }
                    } else {
                        Section(header: Text("Trending")) {
                            ForEach(communities.communities, id: \.community.id) { community in
                                NavigationLink(
                                    destination: {
                                        PostsListView(items: PostsListFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, communityHeading: community.community.title)
                                    }, label: {
                                        CommunityRowView(community: community)
                                    })
                            }
                        }
                    }
                }
                subscribedCommunitiesSection()
            }
            .refreshable {
                let endpoint = "https://lemmy.world/api/v3/community/list?sort=New&limit=50"
                communities.fetch(endpoint: endpoint)
            }
            .onAppear {
                guard !hasAppearedOnce else { return }
                hasAppearedOnce = true
                let endpoint = "https://lemmy.world/api/v3/community/list?sort=New&limit=50"
                communities.fetch(endpoint: endpoint)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct groupedCommunitiesSection: View {
    let props: [[String: String]] = [
        ["title": "Local", "type": "Local", "sort": "Active", "icon": "house.circle.fill", "iconColor": "green"],
        ["title": "All", "type": "All", "sort": "Active", "icon": "building.2.crop.circle.fill", "iconColor": "cyan"],
        ["title": "Top", "type": "All", "sort": "TopWeek", "icon": "chart.line.uptrend.xyaxis.circle.fill", "iconColor": "pink"],
        ["title": "New", "type": "All", "sort": "New", "icon": "star.circle.fill", "iconColor": "yellow"],
    ]
    let communityID = 0

    var body: some View {
        Section(header: Text("Feed")) {
            ForEach(props, id: \.self) { prop in
                NavigationLink(
                    destination: {
                        PostsListView(items: PostsListFetcher(communityID: communityID, prop: prop), prop: prop, communityID: communityID)
                    }, label: {
                        FeedTypeRowView(props: prop)
                    })
            }
        }
    }
}

struct subscribedCommunitiesSection: View {
    var body: some View {
        Section(header: Text("Subscribed")) {
            Text("Login to view subscriptions")
                .foregroundColor(.blue)
//                .padding()
        }
    }
}

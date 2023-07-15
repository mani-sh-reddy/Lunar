//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import Foundation
import Kingfisher
import SwiftUI

struct FeedView: View {
    @Binding var lemmyInstance: String

    var body: some View {
        NavigationView {
            List {
                GeneralCommunitiesView()
                TrendingCommunitiesView(communityFetcher: CommunityFetcher(loadInfinitely: false, sortParameter: "Active", limitParameter: "4"))
                SubscribedCommunitiesView()
            }
            .navigationTitle(lemmyInstance)
        }
    }
}

//                Group {
//                    if !communityFetcher.isLoaded {
//                        Section(header: Text("Trending")) {
//                            HStack {
//                                ProgressView()
//                                Text("Loading Trending Communities").opacity(0.5).padding(.horizontal, 3)
//                            }
//                        }
//                    } else {
//                        Section(header: Text("Trending")) {
//                            ForEach(communityFetcher.communities, id: \.community.id) { community in
//                                NavigationLink(
//                                    destination: {
//                                        PostsListView(postFetcher: PostFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, communityHeading: community.community.title)
//                                    }, label: {
//                                        CommunityRowView(community: community)
//                                    })
//                            }
//                        }
//                    }
//                }
//                subscribedCommunitiesSection()
//            }
//            .refreshable {
//                let endpoint = "https://lemmy.world/api/v3/community/list?sort=New&limit=50"
//                communities.fetch(endpoint: endpoint)
//            }
//            .onAppear {
//                guard !hasAppearedOnce else { return }
//                hasAppearedOnce = true
//                let endpoint = "https://lemmy.world/api/v3/community/list?sort=New&limit=50"
//                communities.fetch(endpoint: endpoint)
//            }
//            .navigationBarTitle(lemmyInstance)
//        }
//    }
// }

struct HomeView_Previews: PreviewProvider {
    @State static var lemmyInstance: String = "lemmy.world"

    static var previews: some View {
        FeedView(lemmyInstance: $lemmyInstance)
    }
}

struct GeneralCommunitiesView: View {
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
                        PostsListView(postFetcher: PostFetcher(communityID: communityID, prop: prop), prop: prop, communityID: communityID)
                    }, label: {
                        FeedTypeRowView(props: prop)
                    })
            }
        }
    }
}

struct SubscribedCommunitiesView: View {
    var body: some View {
        Section(header: Text("Subscribed")) {
            HStack {
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .symbolRenderingMode(.monochrome)
                    .foregroundColor(.blue).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                Text("Login to view subscriptions")
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct TrendingCommunitiesView: View {
    @StateObject var communityFetcher: CommunityFetcher

    var body: some View {
        Section(header: Text("Trending")) {
            ForEach(communityFetcher.communities, id: \.community.id) { community in
                NavigationLink(destination:
                    PostsListView(postFetcher: PostFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, communityHeading: community.community.title)
                ) {
                    CommunityRowView(community: community)
                }
                .onAppear {
                    
                    communityFetcher.loadMoreContentIfNeeded(currentItem: community, loadInfinitely: false)
                }
                .accentColor(Color.primary)
            }
            if communityFetcher.isLoading {
                ProgressView()
            }

//            Button {
//                MoreCommunitiesView(communityFetcher: communityFetcher)
//            } label: {
//                HStack {
//                    Image(systemName: "arrow.right.circle.fill")
//                        .resizable()
//                        .frame(width: 30, height: 30)
//                        .symbolRenderingMode(.hierarchical)
//                        .foregroundColor(.blue)
//
//                    Text("View More")
//                        .padding(.horizontal, 10)
//                }
//            }
            NavigationLink(destination:
                MoreCommunitiesView(communityFetcher: communityFetcher)
            ) {
                HStack {
                    Image(systemName: "ellipsis.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)

                    Text("View More")
                        .padding(.horizontal, 10)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

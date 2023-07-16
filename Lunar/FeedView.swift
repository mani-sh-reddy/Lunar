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
                TrendingCommunitiesView(
                    trendingCommunitiesFetcher: TrendingCommunitiesFetcher(sortParameter: "Hot", limitParameter: "5")
                )
                SubscribedCommunitiesView()
            }
            .navigationTitle(lemmyInstance)
        }
    }
}

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
                        PostsListView(postFetcher: PostFetcher(communityID: communityID, prop: prop), prop: prop, communityID: communityID, title: prop["title"] ?? "")
                    }, label: {
                        FeedTypeRowView(props: prop)
                    }
                )
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
    @StateObject var trendingCommunitiesFetcher: TrendingCommunitiesFetcher
//    @StateObject var communityFetcher: CommunityFetcher

    var body: some View {
        Section(header: Text("Trending")) {
            ForEach(trendingCommunitiesFetcher.communities, id: \.community.id) { community in

                NavigationLink {
                    PostsListView(postFetcher: PostFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, title: community.community.title)
                } label: {
                    CommunityRowView(community: community)
                }
                .accentColor(Color.primary)
            }
            if trendingCommunitiesFetcher.isLoading {
                ProgressView()
            }

            NavigationLink(destination:
                MoreCommunitiesView(
                    communityFetcher: CommunityFetcher(sortParameter: "New", limitParameter: "50"),
                    title: "Explore Communities")
                    .animation(.interactiveSpring, value: 10)
            ) {
                HStack {
                    Image(systemName: "sailboat.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.blue)

                    Text("Explore Communities")
                        .padding(.horizontal, 10)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

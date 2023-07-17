//
//  FeedView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedView: View {
    @Binding var lemmyInstance: String
    @StateObject var networkMonitor = NetworkMonitor()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Feed")) {
                    GeneralCommunitiesView()
                }
                Section(header: Text("Trending")) {
                    TrendingCommunitiesView(trendingCommunitiesFetcher: TrendingCommunitiesFetcher(sortParameter: "Hot", limitParameter: "5"))
                }
                Section(header: Text("Subscribed")) {
                    SubscribedCommunitiesView()
                }
            }
            .navigationTitle(lemmyInstance)
        }
        .onAppear {
            networkMonitor.checkConnection()
        }
        .overlay(alignment: .bottom) {
            if networkMonitor.connected {
                EmptyView()
            } else {
                NoInternetConnectionView()
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
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
        ForEach(props, id: \.self) { prop in
            NavigationLink(destination: PostsListView(postFetcher: PostFetcher(communityID: communityID, prop: prop), prop: prop, communityID: communityID, title: prop["title"] ?? "")) {
                FeedTypeRowView(props: prop)
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
                    .foregroundColor(.blue)
                Text("Login to view subscriptions")
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct TrendingCommunitiesView: View {
    @StateObject var trendingCommunitiesFetcher: TrendingCommunitiesFetcher

    var body: some View {
        ForEach(trendingCommunitiesFetcher.communities, id: \.community.id) { community in
            NavigationLink(destination: PostsListView(postFetcher: PostFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, title: community.community.title)) {
                CommunityRowView(community: community)
            }
        }
        if trendingCommunitiesFetcher.isLoading {
            ProgressView()
        }
        MoreCommunitiesLinkView()
    }
}

struct MoreCommunitiesLinkView: View {
    var body: some View {
        NavigationLink(
            destination: MoreCommunitiesView(communityFetcher: CommunityFetcher(sortParameter: "New", limitParameter: "50"), title: "Explore Communities")
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

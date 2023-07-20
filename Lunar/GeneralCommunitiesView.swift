//
//  GeneralCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

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

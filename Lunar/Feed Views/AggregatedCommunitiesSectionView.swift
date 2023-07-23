//
//  AggregatedCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct AggregatedCommunityButton {
    let title: String
    let type: String
    let sort: String
    let icon: String
    let iconColor: String
}

struct AggregatedCommunitiesSectionView: View {
    let aggregatedCommunityButtons: [[String: String]] = [
        [
            "title": "Local",
            "type": "Local",
            "sort": "Active",
            "icon": "house.circle.fill",
            "iconColor": "green",
        ], [
            "title": "All",
            "type": "All",
            "sort": "Active",
            "icon": "building.2.crop.circle.fill",
            "iconColor": "cyan",
        ], [
            "title": "Top",
            "type": "All",
            "sort": "TopWeek",
            "icon": "chart.line.uptrend.xyaxis.circle.fill",
            "iconColor": "pink",
        ], [
            "title": "New",
            "type": "All",
            "sort": "New",
            "icon": "star.circle.fill",
            "iconColor": "yellow",
        ],
    ]

    var body: some View {
        ForEach(aggregatedCommunityButtons, id: \.self) { button in

            if let title = button["title"],
               let type = button["type"],
               let sort = button["sort"]
            {
                let aggregatedPostsFetcher = AggregatedPostsFetcher(
                    sortParameter: sort,
                    typeParameter: type
                )

                let destination = AggregatedPostsListView(
                    aggregatedPostsFetcher: aggregatedPostsFetcher,
                    title: title
                )

                NavigationLink(destination: destination) {
                    AggregatedCommunityRowView(button: button)
                }
            }
        }
    }
}

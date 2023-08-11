//
//  AggregatedCommunitiesSectionView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct AggregatedCommunitiesSectionView: View {
  let aggregatedCommunityButtons: [[String: String]] = [
    [
      "title": "Local",
      "type": "Local",
      "sort": "Active",
      "icon": "house.circle.fill",
      "iconColor": "green"
    ],
    [
      "title": "All",
      "type": "All",
      "sort": "Active",
      "icon": "building.2.crop.circle.fill",
      "iconColor": "cyan"
    ],
    [
      "title": "Top",
      "type": "All",
      "sort": "TopWeek",
      "icon": "chart.line.uptrend.xyaxis.circle.fill",
      "iconColor": "pink"
    ],
    [
      "title": "New",
      "type": "All",
      "sort": "New",
      "icon": "star.circle.fill",
      "iconColor": "yellow"
    ]
  ]

  var body: some View {
    ForEach(aggregatedCommunityButtons, id: \.self) { button in
      NavigationLink(
        destination: AggregatedPostsListView(
          aggregatedPostsFetcher: AggregatedPostsFetcher(
            sortParameter: button["sort"] ?? "Active",
            typeParameter: button["type"] ?? ""
          ),
          title: button["title"] ?? ""
        )
      ) {
        AggregatedCommunityRowView(button: button)
      }
    }
  }
}

//
//  GeneralCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct CommunityButton: Hashable {
  let title: String
  let type: String
  let sort: String
  let icon: String
  let iconColor: Color
  
  init(title: String, type: String, sort: String, icon: String, iconColor: Color) {
    self.title = title
    self.type = type
    self.sort = sort
    self.icon = icon
    self.iconColor = iconColor
  }
}

struct GeneralCommunitiesView: View {
  let buttons: [CommunityButton] = [
    CommunityButton(title: "Local", type: "Local", sort: "Active", icon: "house.circle.fill", iconColor: .green),
    CommunityButton(title: "All", type: "All", sort: "Active", icon: "building.2.crop.circle.fill", iconColor: .cyan),
    CommunityButton(title: "Top", type: "All", sort: "TopWeek", icon: "chart.line.uptrend.xyaxis.circle.fill", iconColor: .pink),
    CommunityButton(title: "New", type: "All", sort: "New", icon: "star.circle.fill", iconColor: .yellow)
  ]
  
  var body: some View {
    ForEach(buttons, id: \.self) { button in
      NavigationLink {
        PostsView(postsFetcher: PostsFetcher(sortParameter: button.sort, typeParameter: button.type, communityID: 0), title: button.title)
      } label: {
        GeneralCommunityButtonView(button: button)
      }
    }
  }
}

struct GeneralCommunityButtonView: View {
  var button: CommunityButton
  
  var body: some View {
    HStack {
      Image(systemName: button.icon)
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(button.iconColor)
      
      Text(button.title)
        .padding(.horizontal, 10)
    }
  }
}

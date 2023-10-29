//
//  ExploreCommunitiesButton.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SFSafeSymbols
import SwiftUI

struct ExploreCommunitiesButton: View {
  var body: some View {
    let communitiesFetcher = CommunitiesFetcher(limitParameter: 50)
    NavigationLink {
      ExploreCommunitiesView(
        communitiesFetcher: communitiesFetcher,
        title: "Explore Communities"
      )
    } label: {
      HStack {
        Image(systemSymbol: .locationCircleFill)
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

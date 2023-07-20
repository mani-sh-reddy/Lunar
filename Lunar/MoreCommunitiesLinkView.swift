//
//  MoreCommunitiesLinkView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

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

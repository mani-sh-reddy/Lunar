//
//  MoreCommunitiesButtonView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct MoreCommunitiesButtonView: View {
    var body: some View {
        let communitiesFetcher = CommunitiesFetcher(
            sortParameter: "New",
            typeParameter: "All",
            limitParameter: 50
        )

        let destination = MoreCommunitiesView(
            communitiesFetcher: communitiesFetcher,
            title: "Explore Communities"
        )

        NavigationLink(destination: destination) {
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

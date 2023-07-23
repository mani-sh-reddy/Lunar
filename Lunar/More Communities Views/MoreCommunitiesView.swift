//
//  MoreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import SwiftUI

struct MoreCommunitiesView: View {
    @StateObject var communitiesFetcher: CommunitiesFetcher
    var title: String
    @State var sectionHeader: String = "Sorted by New"

    var body: some View {
        List {
            Section(header: Text(sectionHeader)) {
                ForEach(communitiesFetcher.communities, id: \.community.id) { community in

                    let communitySpecificPostsFetcher = CommunitySpecificPostsFetcher(
                        communityID: community.community.id,
                        // TODO: user changeable parameters
                        sortParameter: "Active",
                        typeParameter: "All"
                    )

                    let destination = CommunitySpecificPostsListView(
                        communitySpecificPostsFetcher: communitySpecificPostsFetcher,
                        communityID: community.community.id,
                        title: community.community.title
                    )

                    NavigationLink(destination: destination) {
                        MoreCommunitiesRowView(community: community)
                    }
                    .task {
                        communitiesFetcher.loadMoreContentIfNeeded(currentItem: community)
                    }
                }
            }

            .accentColor(Color.primary)
            if communitiesFetcher.isLoading {
                ProgressView()
            }
        }.listStyle(.insetGrouped)
            .navigationBarTitle(title)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "sparkles") }
            }
            .refreshable {
                await communitiesFetcher.refreshContent()
            }
    }
}

struct MoreCommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let communitiesFetcher = CommunitiesFetcher(
            sortParameter: "Active",
            typeParameter: "All",
            limitParameter: 50
        )
        MoreCommunitiesView(
            communitiesFetcher: communitiesFetcher,
            title: "Explore Communities"
        )
    }
}

//
//  MoreCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 15/07/2023.
//

import SwiftUI

struct MoreCommunitiesView: View {
    @StateObject var communityFetcher: CommunityFetcher
    var title:String

    var body: some View {
        List {
            ForEach(communityFetcher.communities, id: \.community.id) { community in
                NavigationLink(destination:
                                PostsListView(postFetcher: PostFetcher(communityID: community.community.id, prop: [:]), prop: [:], communityID: community.community.id, title: community.community.title)
                ) {
                    CommunityRowView(community: community)
                }
                .onAppear {
                    communityFetcher.loadMoreContentIfNeeded(currentItem: community)
                }
            }

            .accentColor(Color.primary)
            if communityFetcher.isLoading {
                ProgressView()
            }
        }
        .navigationBarTitle(title, displayMode: .inline)
    }
}

struct MoreCommunitiesView_Previews: PreviewProvider {
    static var previews: some View {
        let communityFetcher = CommunityFetcher(sortParameter: "New", limitParameter: "5")
        MoreCommunitiesView(communityFetcher: communityFetcher, title: "New Communities")
    }
}

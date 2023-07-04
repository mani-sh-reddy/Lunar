//
//  CommunityListView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct CommunityListView: View {
    @State private var communities: [CommunitiesArray] = []
    
    var body: some View {
        NavigationView {
            List(communities, id: \.community.id) { community in
                NavigationLink {
                    PostsListView(community: community.community)
                } label: {
                    CommunityRow(community: community.community, counts: community.counts)
                }
            }
            .navigationTitle("Communities")
        }
        .onAppear {
            DataFetcher.fetchData { result in
                switch result {
                case .success(let communities):
                    self.communities = communities
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    DataFetcher.fetchPlaceholderData { placeholderCommunities in
                        self.communities = placeholderCommunities
                    }
                }
            }
        }
    }
}


struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}

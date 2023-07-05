//
//  HomeView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct HomeView: View {
    @State private var communities: [CommunitiesArray] = []
    
    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Feed")) {
                    FeedTypeRowView(feedType: "Local", icon: "house", iconColor: Color.green)
                    FeedTypeRowView(feedType: "All", icon: "globe.americas", iconColor: Color.cyan)
                }
                Section(header: Text("Trending")) {
                    ForEach(communities, id: \.community.id) { community in
                        NavigationLink(destination: PostsListView(community: community.community)) {
                            CommunityRowView(community: community.community, counts: community.counts)
                        }
                    }
                }
                Section(header: Text("Subscribed")) {
                    Text("Login to view subscribed communities")
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Communities")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://lemmy.world/api/v3/community/list?sort=Hot&limit=50") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CommunityModel.self, from: data)
                DispatchQueue.main.async {
                    communities = result.communities
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

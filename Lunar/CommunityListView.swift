//
//  CommunityListView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct CommunityListView: View {
    @State private var communities: [CommunitiesArray] = []
    @State var usePlaceholderData: Bool = false
    
    var body: some View {
        NavigationView {
            List(communities, id: \.community.id) { communities in
                NavigationLink {
                    PostsListView()
                } label: {
                    //                                        let _ = print(community)
                    CommunityRow(community: communities.community, counts: communities.counts)
                }
            }
            .navigationTitle("Communities")
        }
        .onAppear {
            fetchData()
        }
    }
    
    func fetchData() {
        guard let url = URL(string: "https://lemmy.world/api/v3/community/list?sort=Active") else {
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
                //                print(result)
                DispatchQueue.main.async {
                    communities = result.communities
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct CommunityListView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityListView()
    }
}

//
//  CommunityListView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI

struct CommunityListView: View {
    @State private var communities: [CommunityElement] = []

        var body: some View {
            List(communities, id: \.community.id) { community in
                VStack(alignment: .leading) {
                    Text(community.community.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(community.community.description ?? "")
                        .font(.body)
                    // Add more views as needed for other community properties
                }
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
                let result = try JSONDecoder().decode(Welcome.self, from: data)
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

//
//  DataFetcher.swift
//  Lunar
//
//  Created by Mani on 04/07/2023.
//

import SwiftUI

class DataFetcher {
    static func fetchData(completion: @escaping (Result<[CommunitiesArray], Error>) -> Void) {
        guard let url = URL(string: "https://lemmy.world/api/v3/community/list?sort=Active") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Response status code: \(response.statusCode)")
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "Empty Data", code: 0, userInfo: nil)))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CommunityModel.self, from: data)
                completion(.success(result.communities))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    static func fetchPlaceholderData(completion: @escaping ([CommunitiesArray]) -> Void) {
        if let path = Bundle.main.path(forResource: "lemmy-world-active-communities-placeholder", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                let result = try JSONDecoder().decode(CommunityModel.self, from: data)
                completion(result.communities)
            } catch {
                print("Error loading placeholder data: \(error.localizedDescription)")
                completion([])
            }
        } else {
            print("Placeholder data file not found")
            completion([])
        }
    }
}

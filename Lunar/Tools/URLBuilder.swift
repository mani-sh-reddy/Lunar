//
//  URLBuilder.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Foundation
import SwiftUI

/// **Base URL**
/// https://lemmy.world/api/v3/
/// **Communities List**
/// community/list?type_=Local&sort=Active&page=1&limit=10
/// **Community Specific Posts**
/// post/list?type_=Local&sort=Active&page=1&limit=10&community_id=145566
/// **Non Specific Posts**
/// post/list?type_=Local&sort=Active&page=1&limit=10
/// **Comments List**
/// comment/list?type_=Local&sort=Top&max_depth=2&page=1&limit=10&post_id=2021423

class URLBuilder {
    @AppStorage("instanceHostURL") var instanceHostURL = DefaultSettings.instanceURL

    private let endpointPath: String
    private let sortParameter: String
    private let typeParameter: String
    private let currentPage: Int
    private let limitParameter: Int?
    private let communityID: Int?
    private let postID: Int?
    private let maxDepth: Int?

    init(
        endpointPath: String,
        sortParameter: String,
        typeParameter: String,
        currentPage: Int,
        limitParameter: Int? = 10,
        communityID: Int? = nil,
        postID: Int? = nil,
        maxDepth: Int? = nil
    ) {
        self.endpointPath = endpointPath
        self.sortParameter = sortParameter
        self.typeParameter = typeParameter
        self.currentPage = currentPage
        self.limitParameter = limitParameter
        self.communityID = communityID
        self.postID = postID
        self.maxDepth = maxDepth
    }

    func buildURL() -> URLComponents {
        var endpoint = URLComponents()
        var queryParams: [String: String] = [
            "sort": sortParameter,
            "type": typeParameter,
            "limit": String(limitParameter ?? 10),
            "page": String(currentPage),
        ]

        if let communityID {
            queryParams["community_id"] = String(communityID)
        }

        if let postID {
            queryParams["post_id"] = String(postID)
        }

        if let maxDepth {
            queryParams["max_depth"] = String(maxDepth)
        }

        endpoint.scheme = "https"
        endpoint.host = instanceHostURL
        endpoint.path = endpointPath
        endpoint.setQueryItems(with: queryParams)

        return endpoint
    }
}

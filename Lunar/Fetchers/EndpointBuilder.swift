//
//  EndpointBuilder.swift
//  Lunar
//
//  Created by Mani on 23/07/2023.
//

import Defaults
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

struct EndpointParameters {
  var endpointPath: String
  var sortParameter: String?
  var typeParameter: String?
  var currentPage: Int?
  var pageCursor: String?
  var limitParameter: Int?
  var savedOnly: Bool?
  var communityID: Int?
  var personID: Int?
  var postID: Int?
  var maxDepth: Int?
  var jwt: String?
  var searchQuery: String?
  var listingType: String?
  var voteType: Int?
  var instance: String?
  var urlString: String?
}

class EndpointBuilder {
  // If selected instance doesn't match active user, item IDs won't match and user will not be able to perform actions
  @Default(.selectedInstance) var selectedInstance

  private let parameters: EndpointParameters

  init(parameters: EndpointParameters) {
    self.parameters = parameters
  }

  func build(redact: Bool? = false) -> URLComponents {
    var endpoint = URLComponents()
    var queryParams: [String: String?] = [:]

    if let sortParameter = parameters.sortParameter { queryParams["sort"] = String(sortParameter) }
    if let typeParameter = parameters.typeParameter { queryParams["type_"] = String(typeParameter) }
    if let currentPage = parameters.currentPage { queryParams["page"] = String(currentPage) }
    if let limitParameter = parameters.limitParameter { queryParams["limit"] = String(limitParameter) }
    if let savedOnly = parameters.savedOnly { queryParams["saved_only"] = String(savedOnly) }
    if let communityID = parameters.communityID, communityID != 0 { queryParams["community_id"] = String(communityID) }
    if let personID = parameters.personID, personID != 0 { queryParams["person_id"] = String(personID) }
    if let postID = parameters.postID { queryParams["post_id"] = String(postID) }
    if let maxDepth = parameters.maxDepth { queryParams["max_depth"] = String(maxDepth) }
    if let pageCursor = parameters.pageCursor { queryParams["page_cursor"] = String(pageCursor) }

    if redact == false {
      if let jwt = parameters.jwt { queryParams["auth"] = jwt }
    }

    if let searchQuery = parameters.searchQuery { queryParams["q"] = String(searchQuery) }
    if let listingType = parameters.listingType { queryParams["listing_type"] = String(listingType) }
    if let voteType = parameters.voteType { queryParams["score"] = String(voteType) }
    if let urlString = parameters.urlString { queryParams["url"] = String(urlString) }

    endpoint.scheme = "https"

    if let instance = parameters.instance {
      endpoint.host = instance
    } else {
      endpoint.host = selectedInstance
    }

    endpoint.path = parameters.endpointPath
    endpoint.setQueryItems(with: queryParams)

    return endpoint
  }
}

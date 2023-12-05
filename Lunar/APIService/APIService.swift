//
//  APIService.swift
//  Lunar
//
//  Created by Mani on 05/12/2023.
//

import Foundation
import Moya

let lemmyProvider = MoyaProvider<LemmyAPI>()

enum LemmyAPI {
  case listPosts(parameters: ListPostsParameters)
  case createPost(parameters: CreatePostParameters)
}

extension LemmyAPI: TargetType {
  var baseURL: URL {
    return URL(string: "https://lemmy.world/api/v3")!
  }
  
  var path: String {
    switch self {
    case .listPosts: return "/post/list"
    case .createPost: return "/post"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .listPosts: .get
    case .createPost: .post
    }
  }
  
//  var sampleData: Data {
//    return Data() // You can provide sample data for testing
//  }
  
  var task: Task {
    switch self {
    case .listPosts(let parameters):
      var params: [String: Any] = [:]
      if let type = parameters.type { params["type_"] = type }
      if let sort = parameters.sort { params["sort"] = sort }
      if let page = parameters.page { params["page"] = page }
      if let limit = parameters.limit { params["limit"] = limit }
      if let communityId = parameters.communityId { params["community_id"] = communityId }
      if let communityName = parameters.communityName { params["community_name"] = communityName }
      if let savedOnly = parameters.savedOnly { params["saved_only"] = savedOnly }
      if let likedOnly = parameters.likedOnly { params["liked_only"] = likedOnly }
      if let dislikedOnly = parameters.dislikedOnly { params["disliked_only"] = dislikedOnly }
      if let pageCursor = parameters.pageCursor { params["page_cursor"] = pageCursor }
      return .requestParameters(parameters: params, encoding: URLEncoding.default)
    
    case .createPost(parameters: let parameters):
      var params: [String: Any] = [
        "name": parameters.name,
        "community_id": parameters.communityId,
        "language_id": parameters.languageId,
        "auth": parameters.auth
      ]
      if let url = parameters.url { params["url"] = url }
      if let body = parameters.body { params["body"] = body }
      if let nsfw = parameters.nsfw { params["nsfw"] = nsfw }
      return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
  }
  
  var headers: [String: String]? {
    switch self {
    case .createPost(let parameters):
      return ["Authorization": "Bearer \(parameters.auth)"]
    default:
      return ["Content-Type": "application/json"]
    }
  }
}

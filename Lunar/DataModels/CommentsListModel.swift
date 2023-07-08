//
//  CommentsModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Alamofire
import Foundation
import SwiftUI

// MARK: - Welcome

struct CommentsListModel: Codable {
    let comments: [CommentElement]
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCommentElement { response in
//     if let commentElement = response.result.value {
//       ...
//     }
//   }

// MARK: - CommentElement

struct CommentElement: Codable {
    let comment: CommentsListObject
    let creator: CommentsListCreator
    let post: CommentsListPost
    let community: CommentsListCommunity
    let counts: CommentsListCounts
    let creatorBannedFromCommunity: Bool
    let subscribed: CommentSubscribed
    let saved, creatorBlocked: Bool

    enum CodingKeys: String, CodingKey {
        case comment, creator, post, community, counts
        case creatorBannedFromCommunity = "creator_banned_from_community"
        case subscribed, saved
        case creatorBlocked = "creator_blocked"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCommentComment { response in
//     if let commentComment = response.result.value {
//       ...
//     }
//   }

// MARK: - CommentComment

struct CommentsListObject: Codable {
    let id, creatorID, postID: Int
    let content: String
    let removed: Bool
    let published: String
    let deleted: Bool
    let apID: String
    let local: Bool
    let path: String
    let distinguished: Bool
    let languageID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case creatorID = "creator_id"
        case postID = "post_id"
        case content, removed, published, deleted
        case apID = "ap_id"
        case local, path, distinguished
        case languageID = "language_id"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCommunity { response in
//     if let community = response.result.value {
//       ...
//     }
//   }

// MARK: - Community

struct CommentsListCommunity: Codable {
    let id: Int
    let name: String
    let title: String
    let description: String?
    let removed: Bool?
    let published: String
    let updated: String?
    let deleted, nsfw: Bool
    let actorID: String
    let local: Bool?
    let icon: String?
    let banner: String?
    let hidden, postingRestrictedToMods: Bool?
    let instanceID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, title, description, removed, published, updated, deleted, nsfw
        case actorID = "actor_id"
        case local, icon, banner, hidden
        case postingRestrictedToMods = "posting_restricted_to_mods"
        case instanceID = "instance_id"
    }
}

// enum Name: String, Codable {
//    case showerthoughts = "showerthoughts"
// }
//
// enum CommunityPublished: String, Codable {
//    case the20230611T153435679943 = "2023-06-11T15:34:35.679943"
// }
//
// enum Title: String, Codable {
//    case showerthoughts = "Showerthoughts"
// }
//
// enum CommunityUpdated: String, Codable {
//    case the20230703T203245007798 = "2023-07-03T20:32:45.007798"
// }

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCounts { response in
//     if let counts = response.result.value {
//       ...
//     }
//   }

// MARK: - Counts

struct CommentsListCounts: Codable {
    let id, commentID, score, upvotes: Int
    let downvotes: Int
    let published: String
    let childCount, hotRank: Int

    enum CodingKeys: String, CodingKey {
        case id
        case commentID = "comment_id"
        case score, upvotes, downvotes, published
        case childCount = "child_count"
        case hotRank = "hot_rank"
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseCreator { response in
//     if let creator = response.result.value {
//       ...
//     }
//   }

// MARK: - Creator

struct CommentsListCreator: Codable {
    let id: Int
    let name: String
    let banned: Bool
    let published: String
    let actorID: String
    let local, deleted, admin, botAccount: Bool
    let instanceID: Int
    let displayName: String?
    let avatar: String?
    let banner: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id, name, banned, published
        case actorID = "actor_id"
        case local, deleted, admin
        case botAccount = "bot_account"
        case instanceID = "instance_id"
        case displayName = "display_name"
        case avatar, banner, bio
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responsePost { response in
//     if let post = response.result.value {
//       ...
//     }
//   }

// MARK: - Post

struct CommentsListPost: Codable {
    let id: Int
    let name, body: String?
    let creatorID, communityID: Int
    let removed, locked: Bool
    let published: String
    let updated: String?
    let deleted, nsfw: Bool
    let apID: String
    let local: Bool
    let languageID: Int
    let featuredCommunity, featuredLocal: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, body
        case creatorID = "creator_id"
        case communityID = "community_id"
        case removed, locked, published, updated, deleted, nsfw
        case apID = "ap_id"
        case local
        case languageID = "language_id"
        case featuredCommunity = "featured_community"
        case featuredLocal = "featured_local"
    }
}

// enum PostPublished: String, Codable {
//    case the20230707T074748136824 = "2023-07-07T07:47:48.136824"
//    case
// }
//
// enum PostUpdated: String, Codable {
//    case the20230707T074852186606 = "2023-07-07T07:48:52.186606"
// }

enum CommentSubscribed: String, Codable {
    case notSubscribed = "NotSubscribed"
}

//// MARK: - Helper functions for creating encoders and decoders
//
// func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
// }
//
// func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
// }

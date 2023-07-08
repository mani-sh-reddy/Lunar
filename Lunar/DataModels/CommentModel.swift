////
////  CommentsModel.swift
////  Lunar
////
////  Created by Mani on 03/07/2023.
////
//
//
//import Foundation
//import SwiftUI
//import Alamofire
//
//import Foundation
//
//// MARK: - Welcome
//struct CommentModel: Codable {
//    let commentView: CommentView
//    let recipientIDS: [JSONAny]
//
//    enum CodingKeys: String, CodingKey {
//        case commentView = "comment_view"
//        case recipientIDS = "recipient_ids"
//    }
//}
//
//// MARK: - CommentView
//struct CommentView: Codable {
//    let comment: CommentObject
//    let creator: CommentCreator
//    let post: CommentPost
//    let community: CommentCommunity
//    let counts: CommentCounts
//    let creatorBannedFromCommunity: Bool
//    let subscribed: String
//    let saved, creatorBlocked: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case comment, creator, post, community, counts
//        case creatorBannedFromCommunity = "creator_banned_from_community"
//        case subscribed, saved
//        case creatorBlocked = "creator_blocked"
//    }
//}
//
//// MARK: - Comment
//struct CommentObject: Codable {
//    let id, creatorID, postID: Int
//    let content: String
//    let removed: Bool
//    let published: String
//    let deleted: Bool
//    let apID: String
//    let local: Bool
//    let path: String
//    let distinguished: Bool
//    let languageID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case creatorID = "creator_id"
//        case postID = "post_id"
//        case content, removed, published, deleted
//        case apID = "ap_id"
//        case local, path, distinguished
//        case languageID = "language_id"
//    }
//}
//
//// MARK: - Community
//struct CommentCommunity: Codable {
//    let id: Int
//    let name, title, description: String
//    let removed: Bool
//    let published, updated: String
//    let deleted, nsfw: Bool
//    let actorID: String
//    let local: Bool
//    let icon: String
//    let banner: String
//    let hidden, postingRestrictedToMods: Bool
//    let instanceID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, title, description, removed, published, updated, deleted, nsfw
//        case actorID = "actor_id"
//        case local, icon, banner, hidden
//        case postingRestrictedToMods = "posting_restricted_to_mods"
//        case instanceID = "instance_id"
//    }
//}
//
//// MARK: - Counts
//struct CommentCounts: Codable {
//    let id, commentID, score, upvotes: Int
//    let downvotes: Int
//    let published: String
//    let childCount, hotRank: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case commentID = "comment_id"
//        case score, upvotes, downvotes, published
//        case childCount = "child_count"
//        case hotRank = "hot_rank"
//    }
//}
//
//// MARK: - Creator
//struct CommentCreator: Codable {
//    let id: Int
//    let name: String
//    let banned: Bool
//    let published: String
//    let actorID: String
//    let local, deleted, admin, botAccount: Bool
//    let instanceID: Int
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, banned, published
//        case actorID = "actor_id"
//        case local, deleted, admin
//        case botAccount = "bot_account"
//        case instanceID = "instance_id"
//    }
//}
//
//// MARK: - Post
//struct CommentPost: Codable {
//    let id: Int
//    let name, body: String
//    let creatorID, communityID: Int
//    let removed, locked: Bool
//    let published, updated: String
//    let deleted, nsfw: Bool
//    let apID: String
//    let local: Bool
//    let languageID: Int
//    let featuredCommunity, featuredLocal: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, body
//        case creatorID = "creator_id"
//        case communityID = "community_id"
//        case removed, locked, published, updated, deleted, nsfw
//        case apID = "ap_id"
//        case local
//        case languageID = "language_id"
//        case featuredCommunity = "featured_community"
//        case featuredLocal = "featured_local"
//    }
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}

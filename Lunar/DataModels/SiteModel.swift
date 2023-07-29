//
//  SiteModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

// MARK: - Welcome

struct SiteModel: Codable {
    let siteView: SiteView
    let admins: [Admin]
    let version: String
    let myUser: MyUser
    let allLanguages: [AllLanguage]
    let discussionLanguages: [Int]
    let taglines, customEmojis: [JSONAny]

    enum CodingKeys: String, CodingKey {
        case siteView = "site_view"
        case admins, version
        case myUser = "my_user"
        case allLanguages = "all_languages"
        case discussionLanguages = "discussion_languages"
        case taglines
        case customEmojis = "custom_emojis"
    }
}

// MARK: - Admin

struct Admin: Codable {
    let person: AdminPerson
    let counts: AdminCounts
}

// MARK: - AdminCounts

struct AdminCounts: Codable {
    let id, personID, postCount, postScore: Int
    let commentCount, commentScore: Int

    enum CodingKeys: String, CodingKey {
        case id
        case personID = "person_id"
        case postCount = "post_count"
        case postScore = "post_score"
        case commentCount = "comment_count"
        case commentScore = "comment_score"
    }
}

// MARK: - AdminPerson

struct AdminPerson: Codable {
    let id: Int
    let name: String
    let displayName: String?
    let avatar: String
    let banned: Bool
    let published: String
    let actorID: String
    let bio: String?
    let local: Bool
    let banner: String?
    let deleted: Bool
    let matrixUserID: String?
    let admin, botAccount: Bool
    let instanceID: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case displayName = "display_name"
        case avatar, banned, published
        case actorID = "actor_id"
        case bio, local, banner, deleted
        case matrixUserID = "matrix_user_id"
        case admin
        case botAccount = "bot_account"
        case instanceID = "instance_id"
    }
}

// MARK: - AllLanguage

struct AllLanguage: Codable {
    let id: Int
    let code, name: String
}

// MARK: - MyUser

struct MyUser: Codable {
    let localUserView: LocalUserView
    let follows, moderates, communityBlocks, personBlocks: [JSONAny]
    let discussionLanguages: [JSONAny]

//    init() {
//        localUserView = LocalUserView(localUser: LocalUser(id: 0, personID: 0, email: "", showNsfw: false, theme: "", defaultSortType: "", defaultListingType: "", interfaceLanguage: "", showAvatars: false, sendNotificationsToEmail: false, validatorTime: "", showScores: false, showBotAccounts: false, showReadPosts: false, showNewPostNotifs: false, emailVerified: false, acceptedApplication: false, openLinksInNewTab: false),
//                                      person: LocalUserViewPerson(id: 0, name: "", banned: false, published: "", actorID: "", local: false, deleted: false, admin: false, botAccount: false, instanceID: 0),
//                                      counts: AdminCounts(id: 0, personID: 0, postCount: 0, postScore: 0, commentCount: 0, commentScore: 0))
//        follows = []
//        moderates = []
//        communityBlocks = []
//        personBlocks = []
//        discussionLanguages = []
//    }

    enum CodingKeys: String, CodingKey {
        case localUserView = "local_user_view"
        case follows, moderates
        case communityBlocks = "community_blocks"
        case personBlocks = "person_blocks"
        case discussionLanguages = "discussion_languages"
    }
}

// MARK: - LocalUserView

struct LocalUserView: Codable {
    let localUser: LocalUser
    let person: LocalUserViewPerson
    let counts: AdminCounts

    enum CodingKeys: String, CodingKey {
        case localUser = "local_user"
        case person, counts
    }
}

// MARK: - LocalUser

struct LocalUser: Codable {
    let id, personID: Int
    let email: String
    let showNsfw: Bool
    let theme, defaultSortType, defaultListingType, interfaceLanguage: String
    let showAvatars, sendNotificationsToEmail: Bool
    let validatorTime: String
    let showScores, showBotAccounts, showReadPosts, showNewPostNotifs: Bool
    let emailVerified, acceptedApplication: Bool
    let totp2FaURL: String? = ""
    let openLinksInNewTab: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case personID = "person_id"
        case email
        case showNsfw = "show_nsfw"
        case theme
        case defaultSortType = "default_sort_type"
        case defaultListingType = "default_listing_type"
        case interfaceLanguage = "interface_language"
        case showAvatars = "show_avatars"
        case sendNotificationsToEmail = "send_notifications_to_email"
        case validatorTime = "validator_time"
        case showScores = "show_scores"
        case showBotAccounts = "show_bot_accounts"
        case showReadPosts = "show_read_posts"
        case showNewPostNotifs = "show_new_post_notifs"
        case emailVerified = "email_verified"
        case acceptedApplication = "accepted_application"
        case totp2FaURL = "totp_2fa_url"
        case openLinksInNewTab = "open_links_in_new_tab"
    }
}

// MARK: - LocalUserViewPerson

struct LocalUserViewPerson: Codable {
    let id: Int
    let name: String
    let banned: Bool
    let published: String
    let actorID: String
    let local, deleted, admin, botAccount: Bool
    let instanceID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, banned, published
        case actorID = "actor_id"
        case local, deleted, admin
        case botAccount = "bot_account"
        case instanceID = "instance_id"
    }
}

// MARK: - SiteView

struct SiteView: Codable {
    let site: Site
    let localSite: LocalSite
    let localSiteRateLimit: LocalSiteRateLimit
    let counts: SiteViewCounts

    enum CodingKeys: String, CodingKey {
        case site
        case localSite = "local_site"
        case localSiteRateLimit = "local_site_rate_limit"
        case counts
    }
}

// MARK: - SiteViewCounts

struct SiteViewCounts: Codable {
    let id, siteID, users, posts: Int
    let comments, communities, usersActiveDay, usersActiveWeek: Int
    let usersActiveMonth, usersActiveHalfYear: Int

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case users, posts, comments, communities
        case usersActiveDay = "users_active_day"
        case usersActiveWeek = "users_active_week"
        case usersActiveMonth = "users_active_month"
        case usersActiveHalfYear = "users_active_half_year"
    }
}

// MARK: - LocalSite

struct LocalSite: Codable {
    let id, siteID: Int
    let siteSetup, enableDownvotes, enableNsfw, communityCreationAdminOnly: Bool
    let requireEmailVerification: Bool
    let applicationQuestion: String
    let privateInstance: Bool
    let defaultTheme, defaultPostListingType: String
    let hideModlogModNames, applicationEmailAdmins: Bool
    let slurFilterRegex: String
    let actorNameMaxLength: Int
    let federationEnabled, captchaEnabled: Bool
    let captchaDifficulty, published, updated, registrationMode: String
    let reportsEmailAdmins: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case siteID = "site_id"
        case siteSetup = "site_setup"
        case enableDownvotes = "enable_downvotes"
        case enableNsfw = "enable_nsfw"
        case communityCreationAdminOnly = "community_creation_admin_only"
        case requireEmailVerification = "require_email_verification"
        case applicationQuestion = "application_question"
        case privateInstance = "private_instance"
        case defaultTheme = "default_theme"
        case defaultPostListingType = "default_post_listing_type"
        case hideModlogModNames = "hide_modlog_mod_names"
        case applicationEmailAdmins = "application_email_admins"
        case slurFilterRegex = "slur_filter_regex"
        case actorNameMaxLength = "actor_name_max_length"
        case federationEnabled = "federation_enabled"
        case captchaEnabled = "captcha_enabled"
        case captchaDifficulty = "captcha_difficulty"
        case published, updated
        case registrationMode = "registration_mode"
        case reportsEmailAdmins = "reports_email_admins"
    }
}

// MARK: - LocalSiteRateLimit

struct LocalSiteRateLimit: Codable {
    let id, localSiteID, message, messagePerSecond: Int
    let post, postPerSecond, register, registerPerSecond: Int
    let image, imagePerSecond, comment, commentPerSecond: Int
    let search, searchPerSecond: Int
    let published: String

    enum CodingKeys: String, CodingKey {
        case id
        case localSiteID = "local_site_id"
        case message
        case messagePerSecond = "message_per_second"
        case post
        case postPerSecond = "post_per_second"
        case register
        case registerPerSecond = "register_per_second"
        case image
        case imagePerSecond = "image_per_second"
        case comment
        case commentPerSecond = "comment_per_second"
        case search
        case searchPerSecond = "search_per_second"
        case published
    }
}

// MARK: - Site

struct Site: Codable {
    let id: Int
    let name, sidebar, published, updated: String
    let icon, banner: String
    let description: String
    let actorID: String
    let lastRefreshedAt: String
    let inboxURL: String
    let publicKey: String
    let instanceID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, sidebar, published, updated, icon, banner, description
        case actorID = "actor_id"
        case lastRefreshedAt = "last_refreshed_at"
        case inboxURL = "inbox_url"
        case publicKey = "public_key"
        case instanceID = "instance_id"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    public static func == (_: JSONNull, _: JSONNull) -> Bool {
        true
    }

    public var hashValue: Int {
        0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue _: Int) {
        nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        nil
    }

    var stringValue: String {
        key
    }
}

class JSONAny: Codable {
    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: value)
        }
    }
}

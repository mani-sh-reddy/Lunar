//
//  CommunityModel.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let communities: [CommunityElement]
}

// MARK: - CommunityElement
struct CommunityElement: Codable {
    let community: CommunityCommunity
    let subscribed: Subscribed
    let blocked: Bool
    let counts: Counts
}

// MARK: - CommunityCommunity
struct CommunityCommunity: Codable {
    let id: Int
    let name, title: String
    let removed: Bool
    let published: String
    let deleted, nsfw: Bool
    let actorID: String
    let local, hidden, postingRestrictedToMods: Bool
    let instanceID: Int
    let description, updated: String?
    let icon: String?
    let banner: String?

    enum CodingKeys: String, CodingKey {
        case id, name, title, removed, published, deleted, nsfw
        case actorID = "actor_id"
        case local, hidden
        case postingRestrictedToMods = "posting_restricted_to_mods"
        case instanceID = "instance_id"
        case description, updated, icon, banner
    }
}

// MARK: - Counts
struct Counts: Codable {
    let id, communityID, subscribers, posts: Int
    let comments: Int
    let published: String
    let usersActiveDay, usersActiveWeek, usersActiveMonth, usersActiveHalfYear: Int
    let hotRank: Int

    enum CodingKeys: String, CodingKey {
        case id
        case communityID = "community_id"
        case subscribers, posts, comments, published
        case usersActiveDay = "users_active_day"
        case usersActiveWeek = "users_active_week"
        case usersActiveMonth = "users_active_month"
        case usersActiveHalfYear = "users_active_half_year"
        case hotRank = "hot_rank"
    }
}

enum Subscribed: String, Codable {
    case notSubscribed = "NotSubscribed"
}

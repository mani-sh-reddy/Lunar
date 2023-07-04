//
//  LocalUser.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import Foundation

struct LocalUser: Codable {
  let id: Int?
  let personID: Int?
  let email: String?
  let showNsfw: Bool?
  let theme: String?
  let defaultSortType: String?
  let defaultListingType: String?
  let interfaceLanguage: String?
  let showAvatars: Bool?
  let sendNotificationsToEmail: Bool?
  let validatorTime: String?
  let showScores: Bool?
  let showBotAccounts: Bool?
  let showReadPosts: Bool?
  let showNewPostNotifs: Bool?
  let emailVerified: Bool?
  let acceptedApplication: Bool?
  let totp2FaURL: String?
  let openLinksInNewTab: Bool?

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

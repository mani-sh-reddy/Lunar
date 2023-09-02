////
////  LocalSite.swift
////  Lunar
////
////  Created by Mani on 01/09/2023.
////
//
// import Foundation
//
// struct LocalSite: Codable {
//  let id: Int
//  let siteID: Int
//  let siteSetup: Bool?
//  let enableDownvotes: Bool?
//  let enableNsfw: Bool?
//  let communityCreationAdminOnly: Bool?
//  let requireEmailVerification: Bool?
//  let applicationQuestion: String?
//  let privateInstance: Bool?
//  let defaultTheme: String?
//  let defaultPostListingType: String?
//  let hideModlogModNames: Bool?
//  let applicationEmailAdmins: Bool?
//  let slurFilterRegex: String?
//  let actorNameMaxLength: Int?
//  let federationEnabled: Bool?
//  let captchaEnabled: Bool?
//  let captchaDifficulty: String?
//  let published: String?
//  let updated: String?
//  let registrationMode: String?
//  let reportsEmailAdmins: Bool?
//
//  enum CodingKeys: String, CodingKey {
//    case id
//    case siteID = "site_id"
//    case siteSetup = "site_setup"
//    case enableDownvotes = "enable_downvotes"
//    case enableNsfw = "enable_nsfw"
//    case communityCreationAdminOnly = "community_creation_admin_only"
//    case requireEmailVerification = "require_email_verification"
//    case applicationQuestion = "application_question"
//    case privateInstance = "private_instance"
//    case defaultTheme = "default_theme"
//    case defaultPostListingType = "default_post_listing_type"
//    case hideModlogModNames = "hide_modlog_mod_names"
//    case applicationEmailAdmins = "application_email_admins"
//    case slurFilterRegex = "slur_filter_regex"
//    case actorNameMaxLength = "actor_name_max_length"
//    case federationEnabled = "federation_enabled"
//    case captchaEnabled = "captcha_enabled"
//    case captchaDifficulty = "captcha_difficulty"
//    case published, updated
//    case registrationMode = "registration_mode"
//    case reportsEmailAdmins = "reports_email_admins"
//  }
// }
//
//

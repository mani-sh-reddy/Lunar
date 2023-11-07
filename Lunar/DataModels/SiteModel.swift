//
//  SiteModel.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation

struct SiteModel: Codable {
  let siteView: Site?
  //  let admins: [Person]?
  let version: String?
  let myUser: MyUser?
  let allLanguages: [Language]?
  let discussionLanguages: [Int]?
  let taglines: [JSONAny]?
  let customEmojis: [JSONAny]?

  enum CodingKeys: String, CodingKey {
    case siteView = "site_view"
//    case admins
    case version
    case myUser = "my_user"
    case allLanguages = "all_languages"
    case discussionLanguages = "discussion_languages"
    case taglines
    case customEmojis = "custom_emojis"
  }
}

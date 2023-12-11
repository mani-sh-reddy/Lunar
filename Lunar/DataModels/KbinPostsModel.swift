//
//  KbinPostsModel.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation

struct KbinPostsModel: Codable {
  let posts: [KbinPostObject]
  let pagination: KbinPagination
}

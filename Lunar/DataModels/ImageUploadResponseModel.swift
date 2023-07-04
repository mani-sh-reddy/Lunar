//
//  ImageUploadResponseModel.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Foundation

struct ImageUploadResponseModel: Codable {
  let msg: String
  let files: [File]
}

struct File: Codable {
  let file: String
  let deleteToken: String

  enum CodingKeys: String, CodingKey {
    case file
    case deleteToken = "delete_token"
  }
}

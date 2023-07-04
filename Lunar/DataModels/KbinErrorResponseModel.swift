//
//  KbinErrorResponseModel.swift
//  Lunar
//
//  Created by Mani on 11/12/2023.
//

import Foundation

struct KbinErrorResponseModel: Codable {
  let type: String
  let title: String
  let status: Int
  let detail: String
}

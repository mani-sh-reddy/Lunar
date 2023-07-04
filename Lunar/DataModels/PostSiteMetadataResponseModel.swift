//
//  PostSiteMetadataResponseModel.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Foundation

// MARK: - PostSiteMetadataResponseModel

struct PostSiteMetadataResponseModel: Codable {
  let metadata: SiteMetadataObject
}

// MARK: - Metadata

struct SiteMetadataObject: Codable {
  let title: String?
  let description: String?
  let image: String?
}

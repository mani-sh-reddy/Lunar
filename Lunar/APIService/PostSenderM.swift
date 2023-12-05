//
//  PostSender.swift
//  Lunar
//
//  Created by Mani on 16/08/2023.
//

import Alamofire
import Defaults
import Foundation
import Pulse
import SwiftUI

class PostSenderM: ObservableObject {
  @Default(.activeAccount) var activeAccount
  @Default(.appBundleID) var appBundleID
  @Default(.networkInspectorEnabled) var networkInspectorEnabled

  let pulse = Pulse.LoggerStore.shared

  func createPost(parameters: CreatePostParameters, completion: @escaping (String?, Int) -> Void) {
    lemmyProvider.request(.createPost(parameters: parameters)) { result in
      switch result {
      case let .success(response):
        do {
          print(String(data: response.data, encoding: .utf8) ?? "Unable to convert data to string")
          let responseData = try JSONDecoder().decode(CreatePostResponseModel.self, from: response.data)
          let postID = Int(responseData.post?.post.id ?? 0)
          print(String(postID))
          completion("success", postID)
        } catch {
          print("Error decoding create post response: \(error)")
        }
      case let .failure(error):
        print("Network request failed: \(error)")
      }
    }
  }
}

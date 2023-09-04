//
//  InPostThumbnailImageView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import Nuke
import NukeUI
import SwiftUI
import UIKit

struct InPostThumbnailImageView: View {
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID

  var thumbnailURL: String
  var imageRadius: CGFloat = 10

  var body: some View {
    LazyImage(url: URL(string: thumbnailURL)) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: imageRadius, style: .continuous))
      } else if state.error != nil {
        Color.clear
          .aspectRatio(contentMode: .fit)
      } else {
        Color.clear
          .aspectRatio(contentMode: .fit)
      }
    }
    .pipeline(ImagePipeline(configuration: .withDataCache))
  }
}

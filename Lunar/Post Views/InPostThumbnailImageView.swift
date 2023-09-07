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
  var thumbnailURL: String
  var imageRadius: CGFloat = 10
  
  let imagePipeline = ImagePipeline {
    $0 = .withDataCache(sizeLimit: 1024 * 1024 * 2000)
    $0.dataCachePolicy = .storeAll
  }

  var body: some View {
    LazyImage(url: URL(string: thumbnailURL)) { state in
      if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
      } else if state.error != nil {
        Color.clear // Indicates an error
      } else {
        Color.clear // Acts as a placeholder
      }
    }
    .processors([.resize(width: 250)])
    .pipeline(imagePipeline)
    .clipShape(RoundedRectangle(cornerRadius: imageRadius, style: .continuous))
  }
}

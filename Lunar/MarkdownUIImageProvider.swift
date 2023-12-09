//
//  MarkdownUIImageProvider.swift
//  Lunar
//
//  Created by Mani on 09/12/2023.
//

import Foundation
import Nuke
import NukeUI
import MarkdownUI
import SwiftUI

struct LazyImageProvider: ImageProvider {
  @MainActor func makeImage(url: URL?) -> some View {
    let imageRequest = ImageRequest(url: url, processors: [.resize(width: 200)], priority: .low)
    
    LazyImage(request: imageRequest) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
      } else if state.error != nil {
        Color.clear // Indicates an error
      } else {
        Color.clear // Acts as a placeholder
      }
    }
    //    .pipeline(ImagePipeline.shared)
  }
}

extension ImageProvider where Self == LazyImageProvider {
  static var lazyImageProvider: Self {
    .init()
  }
}

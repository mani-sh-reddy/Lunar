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

  var body: some View {
    let imageRequest = ImageRequest(url: URL(string: thumbnailURL), processors: [.resize(width: 200)])

    LazyImage(request: imageRequest) { state in
      if let image = state.image {
        image
          .resizable()
          .aspectRatio(contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: imageRadius, style: .continuous))
      } else if state.error != nil {
        Color.clear // Indicates an error
      } else {
        Color.clear // Acts as a placeholder
      }
    }
  }
}

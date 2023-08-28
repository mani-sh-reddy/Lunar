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
  var body: some View {
    
    
    LazyImage(url: URL(string: thumbnailURL)) { state in
      if let image = state.image {
        image.resizable().aspectRatio(contentMode: .fit)
      } else if state.error != nil {
        Color.clear // Indicates an error
      } else {
        Color.clear // Acts as a placeholder
      }
    }
      .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
  }
}

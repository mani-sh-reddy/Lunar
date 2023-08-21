//
//  InPostThumbnailImageView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import Kingfisher
import Nuke
import NukeUI
import SwiftUI
import UIKit

struct InPostThumbnailImageView: View {
  //    @State private var isLoading = true
  //    var loadImageOnlyFromCache: Bool

  var thumbnailURL: String
  var body: some View {

    LazyImage(url: URL(string: thumbnailURL)) { state in
      if let image = state.image {
        image.resizable().aspectRatio(contentMode: .fit)
      } else if state.error != nil {
        Color.clear  // Indicates an error
      } else {
        Color.clear  // Acts as a placeholder
      }
    }

    //      .cacheOriginalImage(true)
    //      .downsampling(size: CGSize(width: 500, height: 500))
    //            .onProgress { receivedSize, totalSize in
    //                if receivedSize < totalSize {
    //                    isLoading = true
    //                } else {
    //                    isLoading = false
    //                }
    //            }
    //      .cancelOnDisappear(true)
    //      .fade(duration: 0.2)
    //      .progressViewStyle(.circular)
    //      .aspectRatio(contentMode: .fit)
    //            .frame(alignment: .center)
    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    //            .padding(.bottom, 3)
  }
}

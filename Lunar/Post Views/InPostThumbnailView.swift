//
//  InPostThumbnailView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import Kingfisher
import SwiftUI
import UIKit

struct InPostThumbnailView: View {
  @State private var isLoading = true
  @State private var showingPopover = false
  @State private var scale: CGFloat = 1

  var thumbnailURL: String
  var imageRadius: CGFloat = 10

  var body: some View {
    InPostThumbnailImageView(
      thumbnailURL: thumbnailURL,
      imageRadius: imageRadius
    )
    .highPriorityGesture(
      TapGesture().onEnded {
        showingPopover.toggle()
      }
    )
    .popover(isPresented: $showingPopover) {
      ImagePopoverView(showingPopover: $showingPopover, thumbnailURL: thumbnailURL)
    }
  }
}

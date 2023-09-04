//
//  ImagePopoverView.swift
//  Lunar
//
//  Created by Mani on 26/07/2023.
//

import Foundation
import Nuke
import NukeUI
import SwiftUI
import UIKit

struct ImagePopoverView: View {
  @Binding var showingPopover: Bool

  var thumbnailURL: String

  var body: some View {
    ZStack {
      Rectangle().foregroundStyle(.black)
        .ignoresSafeArea()
      LazyImage(url: URL(string: thumbnailURL)) { state in
        if let image = state.image {
          //          image.resizable().aspectRatio(contentMode: .fit)
          PhotoDetailView(image: image.asUIImage())
        } else if state.error != nil {
          Color.clear // Indicates an error
        } else {
          ProgressView()
        }
      }
      //      AsyncImage(url: URL(string: thumbnailURL)) { state in
      //        if let image = state.image {
      //          PhotoDetailView(image: image.asUIImage())
      //        } else {
      //          ProgressView()
      //        }
      //      }
      .edgesIgnoringSafeArea(.all)
    }
  }
}

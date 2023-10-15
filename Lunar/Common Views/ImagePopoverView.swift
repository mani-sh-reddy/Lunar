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
          ZStack {
            Rectangle().foregroundStyle(.black)
              .ignoresSafeArea()
            PhotoDetailView(image: image.asUIImage())
            VStack {
              DismissButtonView(dismisser: $showingPopover).saturation(0).opacity(0.8)
                .padding(.vertical, 30)
              Spacer()
            }
            .edgesIgnoringSafeArea(.all)
          }

        } else if state.error != nil {
          Color.clear // Indicates an error
        } else {
          ProgressView()
        }
      }
      .pipeline(ImagePipeline.shared)
      .edgesIgnoringSafeArea(.all)
    }
  }
}

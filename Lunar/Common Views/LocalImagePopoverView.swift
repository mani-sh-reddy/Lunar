//
//  LocalImagePopoverView.swift
//  Lunar
//
//  Created by Mani on 15/10/2023.
//

import Foundation
import SwiftUI

struct LocalImagePopoverView: View {
  @Binding var showingImagePopover: Bool

  var image: UIImage

  var body: some View {
    ZStack {
      Rectangle().foregroundStyle(.black)
        .ignoresSafeArea()
      PhotoDetailView(image: image)
      VStack {
        DismissButtonView(dismisser: $showingImagePopover).saturation(0).opacity(0.8)
          .padding(.vertical, 30)
        Spacer()
      }
      .edgesIgnoringSafeArea(.all)
    }
  }
}

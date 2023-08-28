//
//  RichLink.swift
//  Lunar
//
//  Created by Mani on 14/08/2023.
//

import Foundation
import LinkPresentation
import SwiftUI
import UIKit

struct LPLinkViewRepresented: UIViewRepresentable {
  var metadata: LPLinkMetadata

  func makeUIView(context: Context) -> LPLinkView {
    metadata.remoteVideoURL = nil
    metadata.videoProvider = nil

    return LPLinkView(metadata: metadata)
  }

  func updateUIView(_ uiView: LPLinkView, context: Context) {

  }
}

struct MetadataView: View {
  @StateObject var vm: LinkViewModel

  var body: some View {
    if let metadata = vm.metadata {
      LPLinkViewRepresented(metadata: metadata)
        .scaledToFit()
        .padding(5)
    } else {
      EmptyView().frame(height: 0)
    }
  }
}

class LinkViewModel: ObservableObject {
  let metadataProvider = LPMetadataProvider()

  @Published var metadata: LPLinkMetadata?

  init(link: String) {
    guard let url = URL(string: link) else {
      return
    }
    metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
      guard error == nil else {
        //        assertionFailure("Error")
        return
      }
      DispatchQueue.main.async {
        self.metadata = metadata
      }
    }
  }
}

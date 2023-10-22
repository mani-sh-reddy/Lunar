//
//  RichLinks.swift
//  Lunar
//
//  Created by Mani on 22/10/2023.
//

import Foundation
import LinkPresentation
import SwiftUI

struct LPLinkViewRepresented: UIViewRepresentable {
  var metadata: LPLinkMetadata

  func makeUIView(context _: Context) -> LPLinkView {
    LPLinkView(metadata: metadata)
  }

  func updateUIView(_: LPLinkView, context _: Context) {}
}

struct MetadataView: View {
  @StateObject var vm: LinkViewModel

  var body: some View {
    VStack {
      if let metadata = vm.metadata {
        LPLinkViewRepresented(metadata: metadata)
      }
    }
  }
}

class LinkViewModel: ObservableObject {
  let metadataProvider = LPMetadataProvider()

  @Published var metadata: LPLinkMetadata?
  @Published var image: UIImage?

  init(link: String) {
    guard let url = URL(string: link) else {
      return
    }
    metadataProvider.startFetchingMetadata(for: url) { metadata, error in
      guard error == nil else {
        assertionFailure("Error")
        return
      }
      DispatchQueue.main.async {
        self.metadata = metadata
      }
      guard let imageProvider = metadata?.imageProvider else { return }
      imageProvider.loadObject(ofClass: UIImage.self) { image, error in
        guard error == nil else {
          // handle error
          return
        }
        if let image = image as? UIImage {
          // do something with image
          DispatchQueue.main.async {
            self.image = image
          }
        } else {
          print("no image available")
        }
      }
    }
  }
}

struct MetadataView_Previews: PreviewProvider {
  static var previews: some View {
    MetadataView(vm: LinkViewModel(link: "https://google.com"))
  }
}

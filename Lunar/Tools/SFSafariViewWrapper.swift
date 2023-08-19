//
//  SFSafariViewWrapper.swift
//  Lunar
//
//  Created by Mani on 14/08/2023.
//

import SafariServices
import SwiftUI

struct SFSafariViewWrapper: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: UIViewControllerRepresentableContext<Self>)
    -> SFSafariViewController
  {
    return SFSafariViewController(url: url)
  }

  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: UIViewControllerRepresentableContext<SFSafariViewWrapper>
  ) {
    return
  }
}

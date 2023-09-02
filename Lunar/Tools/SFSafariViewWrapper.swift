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

  func makeUIViewController(context _: UIViewControllerRepresentableContext<Self>)
    -> SFSafariViewController
  {
    SFSafariViewController(url: url)
  }

  func updateUIViewController(
    _: SFSafariViewController,
    context _: UIViewControllerRepresentableContext<SFSafariViewWrapper>
  ) {}
}

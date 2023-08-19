//
//  SafariView.swift
//  Lunar
//
//  Created by Mani on 14/08/2023.
//

import SafariServices
import SwiftUI
import UIKit

struct SafariView: UIViewControllerRepresentable {
  var url: URL

  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>)
    -> SFSafariViewController
  {
    let safariView = SFSafariViewController(url: url)
    return safariView
  }

  func updateUIViewController(
    _ uiViewController: SFSafariViewController,
    context: UIViewControllerRepresentableContext<SafariView>
  ) {

  }
}

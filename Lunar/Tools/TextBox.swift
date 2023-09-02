//
//  TextBox.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import Foundation
import SwiftUI
import UIKit

// struct TextBox: UIViewRepresentable {
//
//  typealias UIViewType = UITextView
//  var configuration = { (view: UIViewType) in }
//
//  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
//    UIViewType()
//  }
//
//  func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
//    configuration(uiView)
//  }
// }

public extension UITextView {
  func setupPlaceholder(text: String) {
    guard self.text.isEmpty else { return }
    self.text = text
  }

  func setupPlaceholderBeforeEditing(
    textColor: UIColor,
    placeholderColor: UIColor
  ) {
    guard self.textColor == placeholderColor else { return }
    text = ""
    self.textColor = textColor
  }
}

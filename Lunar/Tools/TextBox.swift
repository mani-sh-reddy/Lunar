//
//  TextBox.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import Foundation
import SwiftUI
import UIKit

struct TextBox: UIViewRepresentable {

  typealias UIViewType = UITextView
  var configuration = { (view: UIViewType) in }

  func makeUIView(context: UIViewRepresentableContext<Self>) -> UIViewType {
    UIViewType()
  }

  func updateUIView(_ uiView: UIViewType, context: UIViewRepresentableContext<Self>) {
    configuration(uiView)
  }
}

extension UITextView {

  public func setupPlaceholder(text: String, textColor: UIColor) {
    guard self.text.isEmpty else { return }
    self.text = text
    self.textColor = UIColor.gray
  }

  public func setupPlaceholderBeforeEditing(
    textColor: UIColor,
    placeholderColor: UIColor
  ) {
    guard self.textColor == placeholderColor else { return }
    self.text = ""
    self.textColor = textColor
  }
}

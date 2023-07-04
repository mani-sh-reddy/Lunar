//
//  UITextViewExtension.swift
//  Lunar
//
//  Created by Mani on 21/08/2023.
//

import Foundation
import SwiftUI
import UIKit

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

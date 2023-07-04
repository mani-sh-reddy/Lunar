//
//  SupportedFamiliesExtension.swift
//  WidgetsExtension
//
//  Created by Mani on 12/11/2023.
//

import Foundation
import SwiftUI
import WidgetKit

extension WidgetConfiguration {
  func adaptedSupportedFamilies() -> some WidgetConfiguration {
    if #available(iOS 16, *) {
      self.supportedFamilies([
        .systemSmall,
        .systemMedium,
        .systemLarge,
        .systemExtraLarge,
        .accessoryInline,
        .accessoryCircular,
        .accessoryRectangular,
      ])
    } else {
      supportedFamilies([
        .systemSmall,
        .systemMedium,
        .systemLarge,
        .systemExtraLarge,
      ])
    }
  }
}

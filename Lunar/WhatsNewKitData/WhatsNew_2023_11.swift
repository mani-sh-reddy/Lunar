//
//  WhatsNew_2023_11.swift
//  Lunar
//
//  Created by Mani on 04/11/2023.
//

import Foundation
import WhatsNewKit

extension WhatsNewKitData {
  var WhatsNew_2023_11: WhatsNew {
    WhatsNew(
      version: "2023.11",
      title: "November 2023",
      features: [newAppIcon],
      primaryAction: WhatsNew.PrimaryAction(
        title: "Dismiss",
        backgroundColor: .accentColor,
        foregroundColor: .white
      ),
      secondaryAction: WhatsNew.SecondaryAction(
        title: "Release Notes",
        foregroundColor: .accentColor,
        hapticFeedback: .selection,
        action: .openURL(URL(string: "https://github.com/mani-sh-reddy/Lunar/releases"))
      )
    )
  }
  var newAppIcon: WhatsNew.Feature {
    WhatsNew.Feature(
      image: .init(systemName: "app.gift.fill"),
      title: "New App Icon",
      subtitle: "Subtitle"
    )
  }
}

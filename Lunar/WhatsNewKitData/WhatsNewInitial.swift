//
//  WhatsNewInitial.swift
//  Lunar
//
//  Created by Mani on 14/09/2023.
//

import Foundation
import SFSafeSymbols
import SwiftUI
import WhatsNewKit

class WhatsNewKitData {}
extension WhatsNewKitData {
  var initial: WhatsNew {
    WhatsNew(
      version: "0.0.0",
      title: "Welcome to Lunar",
      features: [
        WhatsNewKitInitialLaunchFeatures().intro,
        WhatsNewKitInitialLaunchFeatures().discover,
        WhatsNewKitInitialLaunchFeatures().auth,
        WhatsNewKitInitialLaunchFeatures().open,
        WhatsNewKitInitialLaunchFeatures().updates,
        WhatsNewKitInitialLaunchFeatures().contribute,
      ],
      primaryAction: WhatsNew.PrimaryAction(
        title: "Get Started",
        backgroundColor: .accentColor,
        foregroundColor: .white
      ),
      secondaryAction: WhatsNew.SecondaryAction(
        title: "Learn More About Lemmy",
        foregroundColor: .accentColor,
        hapticFeedback: .selection,
        action: .present {
          AboutLemmyView()
        }
      )
    )
  }
}

class WhatsNewKitInitialLaunchFeatures {
  let intro = WhatsNew.Feature(
    image: .init(
      systemName: "moonphase.waxing.crescent.inverse",
      foregroundColor: .yellow
    ),
    title: "Thank you for joining the Lunar beta!",
    subtitle: .init(
      try! AttributedString(
        markdown: "Explore the world of [Lemmy](https://join-lemmy.org), communities, instances, and the Fediverse."
      )
    )
  )

  let discover = WhatsNew.Feature(
    image: .init(
      systemName: "rectangle.and.text.magnifyingglass",
      foregroundColor: .blue
    ),
    title: "Discover Communities",
    subtitle: "Discover interesting and trending communities on the Explore Communities page."
  )

  let auth = WhatsNew.Feature(
    image: .init(
      systemName: "lock.fill",
      foregroundColor: .gray
    ),
    title: "Securely Authenticate",
    subtitle: "Login to the Fediverse securely using Apple Keychain."
  )

  let open = WhatsNew.Feature(
    image: .init(
      systemName: "door.left.hand.open",
      foregroundColor: .green
    ),
    title: "Open source",
    subtitle: .init(
      try! AttributedString(
        markdown: "The code for Lunar is available on [Github](https://github.com/mani-sh-reddy/Lunar) and I welcome community involvement."
      )
    )
  )

  let updates = WhatsNew.Feature(
    image: .init(
      systemName: "app.badge.fill",
      foregroundColor: .red
    ),
    title: "Updated Regularly",
    subtitle: .init(
      try! AttributedString(
        markdown: "Lunar is still in early development but I'm committed to improving the app and adding new features regularly."
      )
    )
  )
  let contribute = WhatsNew.Feature(
    image: .init(
      systemName: "pencil.line",
      foregroundColor: .primary
    ),
    title: "Contribute",
    subtitle: .init(
      try! AttributedString(
        markdown: "If you'd like to suggest features or improvements please visit the github repo: [github.com/mani-sh-reddy/Lunar](https://github.com/mani-sh-reddy/Lunar)"
      )
    )
  )
}

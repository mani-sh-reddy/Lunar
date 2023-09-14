//
//  WhatsNewInitialInfo.swift
//  Lunar
//
//  Created by Mani on 14/09/2023.
//

import Foundation
import SwiftUI
import WhatsNewKit

class WhatsNewInitialInfo {
//  let template = WhatsNew.Feature(
//    image: .init(
//      image: Image(systemSymbol: .sparkle)
//    ),
//    title: "New Design",
//    subtitle: .init(
//      try! AttributedString(
//        markdown: "An awesome new _Design_"
//      )
//    )
//  )
  
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

  let keyFeatures = WhatsNew.Feature(
    image: .init(
      systemName: "star.fill",
      foregroundColor: .orange
    ),
    title: "Here are some of Lunar's key features:",
    subtitle: ""
  )

  let auth = WhatsNew.Feature(
    image: .init(
      systemName: "lock.fill",
      foregroundColor: .red
    ),
    title: "Secure Authentication",
    subtitle: "Login to the Fediverse securely using Apple Keychain."
  )

  let discover = WhatsNew.Feature(
    image: .init(
      systemName: "rectangle.and.text.magnifyingglass",
      foregroundColor: .blue
    ),
    title: "Community Discovery",
    subtitle: "Discover interesting and trending communities on the Explore Communities page."
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
      foregroundColor: .brown
    ),
    title: "Regular Updates",
    subtitle: .init(
      try! AttributedString(
        markdown: "Lunar is still in early development but I'm committed to improving the app and adding new features regularly."
      )
    )
  )
  let contribute = WhatsNew.Feature(
    image: .init(
      systemName: "pencil.line",
      foregroundColor: .purple
    ),
    title: "Contribute",
    subtitle: .init(
      try! AttributedString(
        markdown: "If you'd like to suggest features or improvements please visit the github repo: [github.com/mani-sh-reddy/Lunar](https://github.com/mani-sh-reddy/Lunar)"
      )
    )
  )
}

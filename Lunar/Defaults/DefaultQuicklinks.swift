//
//  DefaultQuicklinks.swift
//  Lunar
//
//  Created by Mani on 10/09/2023.
//

import Foundation

class DefaultQuicklinks {
  func getSubscribedQuicklink() -> Quicklink {
    Quicklink(
      title: "Subscribed Feed",
      type: "Subscribed",
      sort: "Active",
      icon: "pin.circle.fill",
      iconColor: "7A219E",
      brightness: 0.2,
      saturation: 1.9
    )
  }

  func getDefaultQuicklinks() -> [Quicklink] {
    [
      Quicklink(
        title: "Local",
        type: "Local",
        sort: "Active",
        icon: "house.circle.fill",
        iconColor: "669D34", /// **green**
        brightness: 0.0,
        saturation: 3
      ),
      Quicklink(
        title: "All",
        type: "All",
        sort: "Active",
        icon: "building.2.crop.circle.fill",
        iconColor: "016E8F", /// **blue**
        brightness: 0.0,
        saturation: 3
      ),
      Quicklink(
        title: "Top",
        type: "All",
        sort: "TopWeek",
        icon: "chart.line.uptrend.xyaxis.circle.fill",
        iconColor: "791A3D", /// **red**
        brightness: 0.0,
        saturation: 3
      ),
      Quicklink(
        title: "New",
        type: "All",
        sort: "New",
        icon: "star.circle.fill",
        iconColor: "C4BC00", /// **yellow**
        brightness: 0.0,
        saturation: 3
      ),
    ]
  }

  func getLockedQuicklinks() -> [Quicklink] {
    [
      Quicklink(
        title: "Local",
        type: "Local",
        sort: "Active",
        icon: "mappin.circle",
        iconColor: "669D34", /// **green**
        brightness: 0.0,
        saturation: 3
      ),
      Quicklink(
        title: "All",
        type: "All",
        sort: "Active",
        icon: "globe.europe.africa",
        iconColor: "016E8F", /// **blue**
        brightness: 0.0,
        saturation: 3
      ),
    ]
  }
}

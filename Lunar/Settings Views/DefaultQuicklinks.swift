//
//  DefaultQuicklinks.swift
//  Lunar
//
//  Created by Mani on 10/09/2023.
//

import Foundation

class DefaultQuicklinks {
  func getDefaultQuicklinks() -> [Quicklink] {
    return [
      Quicklink(
        title: "Local",
        type: "Local",
        sort: "Active",
        icon: "house.circle.fill",
        iconColor: "FECB3E", /// **green**
        brightness: 0.2,
        saturation: 2
      ),
      Quicklink(
        title: "All",
        type: "All",
        sort: "Active",
        icon: "building.2.crop.circle.fill",
        iconColor: "31ADE6", /// **blue**
        brightness: 0.2,
        saturation: 2
      ),
      Quicklink(
        title: "Top",
        type: "All",
        sort: "TopWeek",
        icon: "chart.line.uptrend.xyaxis.circle.fill",
        iconColor: "FF2D55", /// **red**
        brightness: 0.2,
        saturation: 2
      ),
      Quicklink(
        title: "New",
        type: "All",
        sort: "New",
        icon: "star.circle.fill",
        iconColor: "FFCC00", /// **yellow**
        brightness: 0.2,
        saturation: 2
      ),
    ]
  }
}

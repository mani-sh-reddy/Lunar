//
//  SortPicker.swift
//  Lunar
//
//  Created by Mani on 19/09/2023.
//

import Defaults
import SFSafeSymbols
import SwiftUI

enum SortType: String, Defaults.Serializable {
  case active = "Active"
  case hot = "Hot"
  case scaled = "Scaled"
  case new = "New"
  case topDay = "TopDay"
  case topWeek = "TopWeek"
  case topMonth = "TopMonth"
  case topYear = "TopYear"
  case topAll = "TopAll"
  case mostComments = "MostComments"
  case newComments = "NewComments"
}

struct SortPicker: View {
  @Binding var sortType: SortType

  var body: some View {
    Picker(
      "Sort Type", selection: $sortType,
      content: {
        Group {
          // MARK: - Active

          Label {
            Text("Active")
          } icon: {
            Image(systemSymbol: .chartLineUptrendXyaxis)
          }.tag(SortType.active)

          // MARK: - Hot

          Label {
            Text("Hot")
          } icon: {
            Image(systemSymbol: .flameFill)
          }.tag(SortType.hot)

          // MARK: - Scaled

          Label {
            Text("Scaled")
          } icon: {
            Image(systemSymbol: .scalemass)
          }.tag(SortType.scaled)

          // MARK: - New

          Label {
            Text("New")
          } icon: {
            Image(systemSymbol: .sparkles)
          }.tag(SortType.new)

          // MARK: - Top Day

          Label {
            Text("Top Day")
          } icon: {
            Image(systemSymbol: .dCircle)
          }.tag(SortType.topDay)

          // MARK: - Top Week

          Label {
            Text("Top Week")
          } icon: {
            Image(systemSymbol: .wCircle)
          }.tag(SortType.topWeek)

          // MARK: - Top Month

          Label {
            Text("Top Month")
          } icon: {
            Image(systemSymbol: .mCircle)
          }.tag(SortType.topMonth)

          // MARK: - Top Year

          Label {
            Text("Top Year")
          } icon: {
            Image(systemSymbol: .yCircle)
          }.tag(SortType.topYear)

          // MARK: - Top All

          Label {
            Text("Top All")
          } icon: {
            Image(systemSymbol: .arrowUpCircle)
          }.tag(SortType.topAll)

          // MARK: - Most Comments

          Label {
            Text("Most Comments")
          } icon: {
            Image(systemSymbol: .quoteBubble)
          }.tag(SortType.mostComments)

          // MARK: - New Comments

          Label {
            Text("New Comments")
          } icon: {
            Image(systemSymbol: .starBubble)
          }.tag(SortType.newComments)
        }
        .textCase(.none)
      }
    )
    .pickerStyle(.menu)
  }
}

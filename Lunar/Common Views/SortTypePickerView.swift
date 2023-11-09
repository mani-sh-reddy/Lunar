//
//  SortTypePickerView.swift
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

struct SortTypePickerView: View {
  @Binding var sortType: SortType

  var body: some View {
    Picker(
      "Sort Type", selection: $sortType,
      content: {
        Group {
          // MARK: -

          Label {
            Text("Active")
          } icon: {
            Image(systemSymbol: .chartLineUptrendXyaxis)
          }.tag(SortType.active)

          // MARK: -

          Label {
            Text("Hot")
          } icon: {
            Image(systemSymbol: .flameFill)
          }.tag(SortType.hot)

          // MARK: -

          Label {
            Text("Scaled")
          } icon: {
            Image(systemSymbol: .scalemass)
          }.tag(SortType.scaled)

          // MARK: -

          Label {
            Text("New")
          } icon: {
            Image(systemSymbol: .sparkles)
          }.tag(SortType.new)

          // MARK: -

          Label {
            Text("Top Day")
          } icon: {
            Image(systemSymbol: .dCircle)
          }.tag(SortType.topDay)

          // MARK: -

          Label {
            Text("Top Week")
          } icon: {
            Image(systemSymbol: .wCircle)
          }.tag(SortType.topWeek)

          // MARK: -

          Label {
            Text("Top Month")
          } icon: {
            Image(systemSymbol: .mCircle)
          }.tag(SortType.topMonth)

          // MARK: -

          Label {
            Text("Top Year")
          } icon: {
            Image(systemSymbol: .yCircle)
          }.tag(SortType.topYear)

          // MARK: -

          Label {
            Text("Top All")
          } icon: {
            Image(systemSymbol: .arrowUpCircle)
          }.tag(SortType.topAll)

          // MARK: -

          Label {
            Text("Most Comments")
          } icon: {
            Image(systemSymbol: .quoteBubble)
          }.tag(SortType.mostComments)

          // MARK: -

          Label {
            Text("New Comments")
          } icon: {
            Image(systemSymbol: .starBubble)
          }.tag(SortType.newComments)

          // MARK: -
        }
        .textCase(.none)
      }
    )
    .pickerStyle(.menu)
  }
}

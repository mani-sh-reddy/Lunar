//
//  AggregatedCommunityRowView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct AggregatedCommunityRowView: View {
  var button: [String: String]

  // Temporary workaround to be fixed
  var color: Color {
    if button["iconColor"] == "green" {
      return Color.green
    } else if button["iconColor"] == "cyan" {
      return Color.cyan
    } else if button["iconColor"] == "pink" {
      return Color.pink
    } else if button["iconColor"] == "yellow" {
      return Color.yellow
    } else if button["iconColor"] == "red" {
      return Color.red
    } else {
      return Color.gray
    }
  }

  var body: some View {
    HStack {
      Image(systemName: button["icon"] ?? "newspaper.circle.fill")
        .resizable()
        .frame(width: 30, height: 30)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(color)

      Text(button["title"] ?? "Feed")
        .padding(.horizontal, 10)
    }
  }
}

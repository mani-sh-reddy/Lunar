//
//  FeedTypeRowView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedTypeRowView: View {
    var props: [String: String]

    var color: Color {
        if props["iconColor"] == "green" { return Color.green }
        else if props["iconColor"] == "cyan" { return Color.cyan }
        else if props["iconColor"] == "pink" { return Color.pink }
        else if props["iconColor"] == "yellow" { return Color.yellow }
        else if props["iconColor"] == "red" { return Color.red }
        else {
            return Color.gray
        }
    }

    var body: some View {
        HStack {
            Image(systemName: props["icon"] ?? "newspaper.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(color)

            Text(props["title"] ?? "Feed")
                .padding(.horizontal, 10)
        }
    }
}

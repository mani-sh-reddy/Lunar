//
//  FeedTypeRowView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI

struct FeedTypeRowView: View {
    var feedType: String
    var icon: String
    var iconColor: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(iconColor)
            Spacer().frame(width: 15)
            Text(feedType)
        }
    }
}

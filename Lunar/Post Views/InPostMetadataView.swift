//
//  InPostMetadataView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

struct InPostMetadataView: View {
    var bodyText: String
    var iconName: String
    var iconColor: Color
    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 1) {
            Image(systemName: iconName)
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(iconColor)
            Text(String(bodyText))
                .foregroundColor(iconColor)
                .textCase(.uppercase)
        }
        .font(.subheadline)
        .padding(.horizontal, 2)
        .lineLimit(1)
    }
}

//
//  InPostUserView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import Foundation
import SwiftUI

struct InPostUserView: View {
    var text: String
    var iconName: String
    var userAvatar: String?

    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ImageViewWithPlaceholder(imageURL: userAvatar, placeholderSystemName: "person.crop.square.fill")

            Text(String(text))
                .foregroundColor(.gray)
                .textCase(.uppercase)
        }
        .font(.subheadline)
        .padding(.trailing, 2)
        .lineLimit(1)
    }
}

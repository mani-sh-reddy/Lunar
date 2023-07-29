//
//  SettingsAccountNavLabel.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import SwiftUI

struct SettingsAccountNavLabel: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 3) {
                Text(verbatim: "<user>")
                    .fontWeight(.bold)
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text("@lemmy.world")
                    .foregroundStyle(.gray)
                    .padding(.bottom, 5)
            }
        }
    }
}

//
//  PlaceholderView.swift
//  Lunar
//
//  Created by Mani on 05/07/2023.
//

import SwiftUI
import BetterSafariView

struct PlaceholderView: View {
  @State var showingSafari: Bool = false
  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        Image(systemSymbol: .exclamationmarkTriangleFill)
          .imageScale(.medium)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .clipped()
          .font(.title3)
          .padding(.bottom)
        Text("Hocus pocus, this text's a joke-us! Placeholder view, it's all folks! Lorem ipsum, just for fun, sum-dolorum, no harm done! Chuckles here, laughs galore, until the real view takes the floor!")
          .font(.subheadline)
          .fixedSize(horizontal: false, vertical: true)
          .lineSpacing(1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .clipped()
      }
      .padding()
      HStack {
        VStack(alignment: .leading) {
          Text("Follow the progress here:")
            .italic().bold()
            .font(.headline)
          Text("github.com/mani-sh-reddy/Lunar")
            .foregroundColor(.secondary)
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
        Image(asset: "AppIconLight")
          .renderingMode(.original)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 32)
          .clipped()
          .mask { RoundedRectangle(cornerRadius: 8, style: .continuous) }
      }
      .padding(.horizontal)
      .padding(.vertical, 10)
      .background {
        RoundedRectangle(cornerRadius: 0, style: .continuous)
          .fill(Color(.systemGray5))
      }
    }
    .frame(width: 300)
    .clipped()
    .background {
      Rectangle()
        .fill(Color(.systemGray6))
    }
    .mask {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
    }
    .onTapGesture {
      showingSafari.toggle()
    }
    .safariView(isPresented: $showingSafari) {
      BetterSafariView.SafariView(
        url: URL(string: "https://github.com/users/mani-sh-reddy/projects/3/views/5")!,
        configuration: BetterSafariView.SafariView.Configuration(
          entersReaderIfAvailable: false,
          barCollapsingEnabled: true
        )
      )
//      .preferredBarAccentColor(.clear)
//      .preferredControlAccentColor(.accentColor)
      .dismissButtonStyle(.done)
    }
  }
}

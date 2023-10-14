//
//  CommentsViewWorkaroundWarning.swift
//  Lunar
//
//  Created by Mani on 07/07/2023.
//

import SFSafeSymbols
import SwiftUI

struct CommentsViewWorkaroundWarning: View {
  @State var showSafari = false

  var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 0) {
        Image(systemSymbol: .exclamationmarkTriangleFill)
          .imageScale(.medium)
          .symbolRenderingMode(.multicolor)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .leading)
          .clipped()
          .font(.title3)
          .padding(.bottom)
        Text("There's an issue when trying to open the reply box. To fix it, first open up the reply box for a different comment, and then return to this one.")
          .font(.subheadline)
          .fixedSize(horizontal: false, vertical: true)
          .lineSpacing(1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .clipped()
      }
      .padding()
      HStack {
        VStack(alignment: .leading) {
          Text("Workaround for issue #236")
            .font(.subheadline)
            .fontWeight(.semibold)
          Text("github.com/mani-sh-reddy/Lunar/")
            .foregroundColor(.secondary)
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .clipped()
      }
      .padding(.horizontal)
      .padding(.vertical, 10)
      .background {
        RoundedRectangle(cornerRadius: 0, style: .continuous)
          .fill(Color(.systemGray5))
      }
    }
    .frame(width: 280)
    .clipped()
    .background {
      Rectangle()
        .fill(Color(.systemGray6))
    }
    .mask {
      RoundedRectangle(cornerRadius: 16, style: .continuous)
    }
    .onTapGesture {
      showSafari = true
    }
    .inAppSafari(
      isPresented: $showSafari,
      stringURL: "https://github.com/mani-sh-reddy/Lunar/issues/236"
    )
  }
}

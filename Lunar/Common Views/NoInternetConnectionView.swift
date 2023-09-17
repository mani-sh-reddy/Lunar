//
//  NoInternetConnectionView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI
import SFSafeSymbols

struct NoInternetConnectionView: View {
  var body: some View {
    ZStack(alignment: .leading) {
      HStack {
        Image(systemSymbol: .wifiExclamationmark)
          .imageScale(.medium)
          .symbolRenderingMode(.hierarchical)
          .foregroundColor(.white)
        Spacer()
          .frame(width: 2)
          .clipped()
        Text("No Internet")
          .foregroundColor(.white)
          .lineLimit(0)
          .clipped()
      }
      .padding(.horizontal, 10)
      .padding(.vertical, 3)
      .frame(alignment: .center)
      .background {
        Capsule(style: .continuous)
          .fill(Color(.red))
      }
    }
    .padding()
  }
}

struct NoInternetConnectionView_Previews: PreviewProvider {
  static var previews: some View {
    NoInternetConnectionView()
  }
}

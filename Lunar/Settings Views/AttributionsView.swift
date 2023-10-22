//
//  AttributionsView.swift
//  Lunar
//
//  Created by Mani on 21/10/2023.
//

import Defaults
import Pulse
import PulseUI
import SFSafeSymbols
import SwiftUI

struct AttributionsView: View {
  let attributions = AttributionInfo().attributions
  let monospaced = Font
    .system(size: 12)
    .monospaced()
  var body: some View {
    ForEach(attributions, id: \.id) { attribution in
      NavigationLink {
        List {
          Section {
            ZStack {
              HStack {
                Spacer()
                ProgressView()
                Spacer()
              }
              MetadataView(vm: LinkViewModel(link: attribution.url))
            }
          }
          Section {
            Text(attribution.license)
              .font(monospaced)
          }
        }
        .navigationTitle(attribution.packageName)
      } label: {
        VStack(alignment: .leading, spacing: 1) {
          Text(attribution.packageName)
            .bold()
            .padding(.top, 1)
          Text(attribution.url)
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.bottom, 1)
        }
      }
    }
  }
}

struct AttributionsView_Previews: PreviewProvider {
  static var previews: some View {
    List {
      Section {
        MetadataView(vm: LinkViewModel(link: "https://github.com/mani-sh-reddy"))
      }
      Section {
        Text("None")
      }
    }
  }
}

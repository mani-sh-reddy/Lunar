//
//  LegacyKbinMagazinesSectionView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import Defaults
import SwiftUI

struct LegacyKbinMagazinesSectionView: View {
  @Default(.legacyKbinSelectedInstance) var legacyKbinSelectedInstance

  var body: some View {
    NavigationLink {
      LegacyKbinThreadsView(kbinThreadsFetcher: LegacyKbinThreadsFetcher())
    } label: {
      HStack {
        Image("KbinSymbol")
          .resizable()
          .frame(width: 30, height: 30)
          .symbolRenderingMode(.hierarchical)

        Text(legacyKbinSelectedInstance)
          .padding(.horizontal, 10)
      }
    }
  }
}

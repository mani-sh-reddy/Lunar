//
//  KbinMagazinesSectionView.swift
//  Lunar
//
//  Created by Mani on 06/08/2023.
//

import SwiftUI

struct KbinMagazinesSectionView: View {
  @AppStorage("kbinActive") var kbinActive = Settings.kbinActive

  var body: some View {
    if kbinActive {
      NavigationLink {
        KbinThreadsView(kbinThreadsFetcher: KbinThreadsFetcher())
      } label: {
        HStack {
          Image("KbinSymbol")
            .resizable()
            .frame(width: 30, height: 30)
            .symbolRenderingMode(.hierarchical)

          Text("Kbin")
            .padding(.horizontal, 10)
        }
      }
    }
  }
}

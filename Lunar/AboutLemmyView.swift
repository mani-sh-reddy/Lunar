//
//  AboutLemmyView.swift
//  Lunar
//
//  Created by Mani on 21/10/2023.
//

import Defaults
import Pulse
import PulseUI
import SFSafeSymbols
import SwiftUI

struct AboutLemmyTab: View {
  @Environment(\.dismiss) var dismiss
  var sections: ([LemmyInfoSection], String)

  var body: some View {
    List {
      Section {
        HStack {
          Text(sections.1)
            .font(.title)
            .bold()
          Spacer()
          Button {
            dismiss()
          } label: {
            Image(systemSymbol: .xmarkCircleFill)
              .font(.largeTitle)
              .foregroundStyle(.secondary)
              .saturation(0)
          }
        }
      }
      .listRowBackground(Color.clear)
      ForEach(sections.0, id: \.title) { item in
        Section {
          VStack(alignment: .leading) {
            HStack {
              Image(systemSymbol: item.icon)
                .font(.title2)
              Text(item.title)
                .font(.headline)
            }
            .padding(.bottom, 3)
            Text(item.description)
          }
        }
      }
    }
  }
}

struct AboutLemmyView: View {
  var body: some View {
    TabView {
      AboutLemmyTab(sections: AboutLemmyInfo().introSections)
      AboutLemmyTab(sections: AboutLemmyInfo().gettingStartedSections)
      AboutLemmyTab(sections: AboutLemmyInfo().mediaSections)
      AboutLemmyTab(sections: AboutLemmyInfo().voteAndRankingSections)
      AboutLemmyTab(sections: AboutLemmyInfo().moderationSections)
      AboutLemmyTab(sections: AboutLemmyInfo().censorshipSections)
      AboutLemmyTab(sections: AboutLemmyInfo().otherSections)
      AboutLemmyTab(sections: AboutLemmyInfo().historySections)
    }
    .ignoresSafeArea(.all)
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    .tabViewStyle(.page)
  }
}

#Preview {
  AboutLemmyView()
}

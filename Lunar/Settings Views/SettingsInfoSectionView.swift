//
//  SettingsInfoSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI
import SafariServices

struct SettingsInfoSectionView: View {
  @State private var showSafariGithub: Bool = false
  @State private var showSafariLemmy: Bool = false
  
  var body: some View {
    Section {
      // MARK: - Privacy Policy
      Button {
      } label: {
        Label {
          Text("Privacy Policy")
            .foregroundStyle(.foreground)
        } icon: {
          Image(systemName: "shield.lefthalf.filled")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.red)
        }
      }
      .foregroundStyle(.foreground)
      // MARK: - Contact
      Button {
        showSafariLemmy = true
      } label: {
        Label {
          Text("Contact")
            .foregroundStyle(.foreground)
        } icon: {
          Image(systemName: "paperplane.fill")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.blue)
        }
      }
      .foregroundStyle(.foreground)
      .fullScreenCover(isPresented: $showSafariLemmy, content: {
        SFSafariViewWrapper(url: URL(string: "https://lemmy.world/c/lunar" )!).ignoresSafeArea()
      })
      // MARK: - Github
      Button {
        showSafariGithub = true
      } label: {
        Label {
          Text("Github")
        } icon: {
          Image(systemName: "ellipsis.curlybraces")
            .symbolRenderingMode(.hierarchical)
        }
      }
      .foregroundStyle(.foreground)
      .fullScreenCover(isPresented: $showSafariGithub, content: {
        SFSafariViewWrapper(url: URL(string: "https://github.com/mani-sh-reddy/Lunar" )!).ignoresSafeArea()
      })
      
    } header: {
      Text("Info")
    }
  }
}

struct SettingsInfoSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsInfoSectionView()
  }
}

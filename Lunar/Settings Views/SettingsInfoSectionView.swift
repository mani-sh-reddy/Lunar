//
//  SettingsInfoSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsInfoSectionView: View {
    var body: some View {
        Section {
            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Privacy Policy")
                } icon: {
                    Image(systemName: "eye.slash.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.pink)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Contact")
                } icon: {
                    Image(systemName: "paperplane.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Lunar for Lemmy Github")
                } icon: {
                    Image(systemName: "ellipsis.curlybraces")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.foreground)
                }
            }
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

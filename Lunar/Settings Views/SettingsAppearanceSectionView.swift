//
//  SettingsAppearanceSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsAppearanceSectionView: View {
    var body: some View {
        Section {
            NavigationLink {
                SettingsAppIconView()
            } label: {
                Label {
                    Text("App Icon")
                } icon: {
                    Image(systemName: "app.dashed")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.gray)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Theme")
                } icon: {
                    Image(systemName: "paintbrush")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.indigo)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Layout")
                } icon: {
                    Image(systemName: "square.on.square.squareshape.controlhandles")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.mint)
                }
            }

        } header: {
            Text("Appearance")
        }
    }
}

struct SettingsAppearanceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAppearanceSectionView()
    }
}

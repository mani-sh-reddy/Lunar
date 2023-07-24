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
                    Image(systemName: "lock.doc")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.red)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Contact")
                } icon: {
                    Image(systemName: "person.crop.circle")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.blue)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Github")
                } icon: {
                    Image(systemName: "link")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.black)
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

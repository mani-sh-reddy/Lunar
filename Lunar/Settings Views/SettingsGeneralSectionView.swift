//
//  SettingsGeneralSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsGeneralSectionView: View {
    var body: some View {
        Section {
            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Notifications")
                } icon: {
                    Image(systemName: "bell.badge.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.red)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Gestures")
                } icon: {
                    Image(systemName: "hand.draw.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.cyan)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Sounds and Haptics")
                } icon: {
                    Image(systemName: "speaker.wave.2.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.green)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Composer")
                } icon: {
                    Image(systemName: "pencil.line")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.indigo)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Search")
                } icon: {
                    Image(systemName: "magnifyingglass")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.teal)
                }
            }

            NavigationLink {
                PlaceholderView()
            } label: {
                Label {
                    Text("Feed Options")
                } icon: {
                    Image(systemName: "checklist")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.brown)
                }
            }
        } header: {
            Text("General")
        }
    }
}

struct SettingsGeneralSectionView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsGeneralSectionView()
    }
}

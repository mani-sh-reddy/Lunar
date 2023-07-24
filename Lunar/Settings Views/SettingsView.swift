//
//  SettingsView.swift
//  Lunar
//
//  Created by Mani on 14/07/2023.
//

import Kingfisher
import SwiftUI

struct SettingsView: View {
    @AppStorage("instanceHostURL") var instanceHostURL = Settings.instanceHostURL
    @AppStorage("displayName") var displayName = Settings.displayName
    @AppStorage("userName") var userName = Settings.userName

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    SettingsAccountView()
                } label: {
                    SettingsAccountNavLabel()
                }

                SettingsServerSelectionSectionView()

                SettingsGeneralSectionView()
                SettingsAppearanceSectionView()
                SettingsInfoSectionView()

                SettingsClearCacheButtonView()
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//                VStack(spacing: 30) {
//                    Text(instanceHostURL)
//                    TextField("Enter username...", text: $instanceHostURL)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    Text("Disk cache size: \(cacheSize)")
//                    Button("clear cache") {
//                        clearCache()
//                    }
//                }.task {
//                    calculateCache()
//                }

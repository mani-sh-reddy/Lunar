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

    @State var selectedName = ""
    @State var selectedEmail = ""
    @State var selectedUserURL = ""

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
//                    SettingsAccountView(siteFetcher: SiteFetcher())
                    SettingsAccountView(selectedName: $selectedName, selectedEmail: $selectedEmail, selectedUserURL: $selectedUserURL)
                } label: {
                    SettingsSelectedUserLabel(selectedName: $selectedName, selectedEmail: $selectedEmail, selectedUserURL: $selectedUserURL)
                }

                SettingsServerSelectionSectionView()

                SettingsGeneralSectionView()
                SettingsAppearanceSectionView()
                SettingsInfoSectionView()

                SettingsHiddenOptionsView()

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

//
//  SettingsAccountView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsAccountView: View {
    var body: some View {
        List {
            Text("Account Setting Placeholder 1")
            Text("Account Setting Placeholder 2")
            Text("Account Setting Placeholder 3")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { Image(systemName: "person.badge.plus")
                .symbolRenderingMode(.hierarchical)
//                    .foregroundStyle(.blue)
            }
        }
    }
}

struct SettingsAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsAccountView()
    }
}

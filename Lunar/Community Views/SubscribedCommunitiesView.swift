//
//  SubscribedCommunitiesView.swift
//  Lunar
//
//  Created by Mani on 20/07/2023.
//

import SwiftUI

struct SubscribedCommunitiesView: View {
    var body: some View {
        HStack {
            Image(systemName: "lock.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .symbolRenderingMode(.monochrome)
                .foregroundColor(.blue)
            Text("Login to view subscriptions")
                .foregroundColor(.blue)
                .padding(.horizontal, 10)
        }
    }
}

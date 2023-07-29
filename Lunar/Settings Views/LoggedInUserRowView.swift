//
//  LoggedInUserRowView.swift
//  Lunar
//
//  Created by Mani on 29/07/2023.
//

import Foundation
import SwiftUI

struct LoggedInUserRowView: View {
    var username: String

    var body: some View {
        Text(username)
    }
}

struct LoggedInUserRowView_Previews: PreviewProvider {
    var username: String

    static var previews: some View {
        LoggedInUserRowView(username: "")
    }
}

//
//  UserRowView.swift
//  Lunar
//
//  Created by Mani on 28/07/2023.
//

import Foundation
import SwiftUI

struct UserRowView: View {
    @State var username: String = ""

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.square.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 3) {
                Text(username)
                    .fontWeight(.bold)
                    .font(.title)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text("@lemmy.world")
                    .foregroundStyle(.gray)
                    .padding(.bottom, 5)
            }
        }
    }
}

struct UserRowView_Previews: PreviewProvider {
    static var previews: some View {
        UserRowView()
    }
}

//
//  UserInfoView.swift
//  Lunar
//
//  Created by Mani on 05/08/2023.
//

import Kingfisher
import SwiftUI

struct UserInfoView: View {
    var person: Creator
    var hasBanner: Bool {
        person.banner != "" && person.banner != nil
    }

    var hasAvatar: Bool {
        person.avatar != "" && person.avatar != nil
    }

    var body: some View {
        ScrollView {
            if hasBanner {
                ZStack {
                    KFImage(URL(string: person.banner ?? ""))
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding()
                }
            }

            VStack(alignment: .leading) {
                HStack {
                    if hasAvatar {
                        KFImage(URL(string: person.avatar ?? ""))
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .frame(maxWidth: 50, maxHeight: 50)
                            .padding(5)
                    }
                    VStack(alignment: .leading) {
                        Text(person.name)
                            .font(.title).bold()
                        Text("@\(URLParser.extractDomain(from: person.actorID))").font(.headline)
                    }
                }.padding(.bottom, 10)

                if let bio = person.bio {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .foregroundStyle(.ultraThinMaterial)
                        Text(bio)
                            .padding(10)
                    }
                }
            }.padding()
        }
    }
}

struct UserInfoView_Previews: PreviewProvider {
    static var previews: some View {
        UserInfoView(person: MockData.userInfoView)
    }
}

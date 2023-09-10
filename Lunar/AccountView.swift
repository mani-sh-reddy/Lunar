//
//  AccountTabView.swift
//  Lunar
//
//  Created by Mani on 03/07/2023.
//

import SwiftUI
import NukeUI

struct AccountTabView: View {
  @AppStorage("selectedAvatarURL") var selectedAvatarURL = Settings.selectedAvatarURL
  @AppStorage("selectedName") var selectedName = Settings.selectedName
  @AppStorage("selectedEmail") var selectedEmail = Settings.selectedEmail
  @AppStorage("selectedActorID") var selectedActorID = Settings.selectedActorID
  
  var userInstance: String {
    "@\(URLParser.extractDomain(from: selectedActorID))"
  }
  
  var body: some View {
    ScrollView {
      LazyImage(url: URL(string: selectedAvatarURL)) { state in
        if let image = state.image {
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
        } else if state.error != nil {
          placeholderImage
        } else {
          placeholderImage
        }
      }
      .symbolRenderingMode(.hierarchical)
      .frame(width: 150, height: 150)
      .padding(30)
      userInfo
    }
  }
  var placeholderImage: some View {
    Image(systemName: "person.crop.circle.fill")
      .resizable()
      .foregroundStyle(.gray)
  }
  var userInfo: some View {
    VStack{
      Text(selectedName)
        .font(.title).bold()
        .padding(5)
      Text(userInstance)
        .font(.title)
        .padding(5)
    }
  }
}

struct AccountTabView_Previews: PreviewProvider {
  static var previews: some View {
    AccountTabView()
  }
}

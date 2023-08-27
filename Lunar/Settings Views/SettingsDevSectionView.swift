//
//  SettingsDevSectionView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsDevSectionView: View {
  var body: some View {
    Section {

      NavigationLink {
        SettingsDevOptionsView()
      } label: {
        Label {
          Text("Developer Options")
        } icon: {
          Image(systemName: "wrench.and.screwdriver.fill")
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.red)
        }
      }
    } header: {
      Text("Extras")
    } footer: {
      HStack(){
        Spacer()
        VStack(alignment: .center){
          Text("~ made by mani ~")
            .padding(.bottom, 5)
          Text(LocalizedStringKey("[mani-sh-reddy.github.io](http://mani-sh-reddy.github.io/)"))
        }
        Spacer()
      }.padding(.vertical, 40)
      
    }
  }
}

struct SettingsDevSectionView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsDevSectionView()
  }
}

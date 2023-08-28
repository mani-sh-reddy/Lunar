//
//  SettingsDevOptionsView.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import SwiftUI

struct SettingsDevOptionsView: View {
  @AppStorage("appBundleID") var appBundleID = Settings.appBundleID
  @AppStorage("enableLogging") var enableLogging = Settings.enableLogging
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("logs") var logs = Settings.logs
  
  @State var refreshView: Bool = false
  @State var settingsViewOpacity: Double = 1
  @State var refreshIconOpacity: Double = 0
  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0
  
  var body: some View {
    List{
      Section {
        //        SettingsHiddenOptionsView()
        Toggle(isOn: $enableLogging) {
          Text("Enable Logging")
        }
        if enableLogging {
          NavigationLink {
            LogsView()
          } label: {
            Text("Logs")
          }
        }
        ShareLogsButton()
      }
      Section {
        ClearLogsButton()
      }
      Section {
        SettingsClearCacheButtonView()
      }
      Section {
        AppResetButton(refreshView: $refreshView)
      }
    }
    .onChange(of: refreshView) { _ in
      refresh()
    }
    .opacity(settingsViewOpacity)
    .overlay {
      Image("LunarLogo")
        .resizable()
        .scaledToFit()
        .padding(50)
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    }
    .navigationTitle("Developer Options")
  }
  
  func refresh(){
    settingsViewOpacity = 0
    logoScale = 1.0
    logoOpacity = 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      withAnimation(.easeIn) {
        settingsViewOpacity = 1
      }
      withAnimation(.easeInOut(duration: 1)) {
        logoScale = 0.8
      }
      withAnimation(Animation.easeInOut(duration: 1.0).delay(0)) {
        logoOpacity = 0
      }
    }
  }
}

struct SettingsDevOptionsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsDevOptionsView()
      .previewLayout(.sizeThatFits)
  }
}

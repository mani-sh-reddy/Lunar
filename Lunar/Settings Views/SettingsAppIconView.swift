////
////  SettingsAppIconView.swift
////  Lunar
////
////  Created by Mani on 27/07/2023.
////
//
//import Foundation
//import SwiftUI
//
//struct SettingsAppIconView: View {
//  @AppStorage("appIconName") var appIconName = Settings.appIconName
//  /// prepended by "AppIcon"
//  let appIconSuffixes = ["Light", "Dark", "Night", "Indigo", "LemmY", "Kbin"]
//
//  var body: some View {
//    List {
//      ForEach(appIconSuffixes, id: \.self) { appIconSuffix in
//        Button(
//          action: {
//            if appIconName != "AppIcon\(appIconSuffix)" {
//              appIconName = "AppIcon\(appIconSuffix)"
//              changeAppIcon(to: appIconName)
//            }
//          },
//          label: {
//            HStack(spacing: 20) {
//              Image(asset: "AppIcon\(appIconSuffix)")
//                .resizable()
//                .frame(width: 50, height: 50)
//                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//              Text("\(appIconSuffix)").foregroundStyle(.foreground)
//              Spacer()
//              Image(systemName: "checkmark.circle.fill")
//                .font(.title2)
//                .symbolRenderingMode(.hierarchical)
//                .foregroundStyle(.indigo)
//                .opacity(appIconName == "AppIcon\(appIconSuffix)" ? 1 : 0)
//            }.onAppear {
//              // Check if it's the first app launch, and if yes, set the initial app icon
//              if !UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
//                UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
//                // Assuming light mode as the default icon for the first install
//                appIconName = "AppIconLight"
//              }
//            }
//          })
//      }
//    }
//    .navigationTitle("App Icon")
//  }
//
//  private func changeAppIcon(to iconName: String) {
//    UIApplication.shared.setAlternateIconName(iconName) { error in
//      if let error {
//        print("Error setting alternate icon \(error.localizedDescription)")
//      }
//    }
//  }
//}
//
//struct SettingsAppIconView_Previews: PreviewProvider {
//  static var previews: some View {
//    SettingsAppIconView()
//  }
//}

////
////  SettingsThemeView.swift
////  Lunar
////
////  Created by Mani on 27/07/2023.
////
//
//import Defaults
//import SFSafeSymbols
//import SwiftUI
//
//struct SettingsThemeView: View {
//  @AppStorage("appAppearance") var appAppearance: AppearanceOptions = .system
//
//  @Default(.accentColor) var accentColor
//  @Default(.accentColorString) var accentColorString
//
//  var accentColorsList: [String] = [
//    "blue",
//    "indigo",
//    "purple",
//    "pink",
//    "red",
//    "orange",
//    "yellow",
//    "brown",
//    "green",
//    "mint",
//    "cyan",
//    "gray",
//  ]
//
//  var body: some View {
//    List {
//      Section {
//        appearancePicker
//        accentColorPicker
//      }
//      iridescenceSection
//    }
//    .navigationTitle("Theme")
//  }
//
//  var appearancePicker: some View {
//    Picker("Appearance", selection: $appAppearance) {
//      ForEach(AppearanceOptions.allCases, id: \.self) { option in
//        Text(option.rawValue.capitalized)
//      }
//    }
//    .pickerStyle(.menu)
//    .onChange(of: appAppearance) { _ in
//      AppearanceController.shared.setAppearance()
//    }
//  }
//
//  var accentColorPicker: some View {
//    HStack {
//      Text("Accent Color")
//      Spacer()
//      Menu {
//        Button {
//          accentColor = ColorConverter().convertStringToColor("blue")
//          accentColorString = "Default"
//        } label: {
//          Text("Default")
//        }
//        ForEach(accentColorsList, id: \.self) { color in
//          HStack {
//            Button {
//              accentColor = ColorConverter().convertStringToColor(color)
//              accentColorString = color.capitalized
//            } label: {
//              Text(color.capitalized)
//            }
//          }
//        }
//
//      } label: {
//        Text(accentColorString)
//          .foregroundStyle(accentColor)
//          .tint(accentColor)
//      }
//    }
//  }
//
//}
//
//#Preview {
//  SettingsThemeView()
//}

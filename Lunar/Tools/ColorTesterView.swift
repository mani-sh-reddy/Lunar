//
//  ColorTesterView.swift
//  Lunar
//
//  Created by Mani on 10/09/2023.
//

import Foundation
import SwiftUI
import SFSafeSymbols

struct customColor: Codable, Hashable {
  var colorHex: String
  var brightness: Double
  var saturation: Double
}

struct ColorTesterView: View {
  @Environment(\.colorScheme) var colorScheme
  @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled
  @AppStorage("savedColors") var savedColors = Settings.savedColors

  @State var quicklinkColor: Color = .blue
  @State var brightness: Double = 0.3
  @State var saturation: Double = 2
  @State var isListDarkMode: Bool = true

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("#\(quicklinkColor.toHex() ?? "Color Tester")")
          .bold()
          .font(.largeTitle)
          .padding(0)
        Spacer()
        AppearanceSwitcherButton(isListDarkMode: $isListDarkMode)
        ColorPicker("Icon Color", selection: $quicklinkColor, supportsOpacity: false)
          .scaleEffect(2)
          .labelsHidden()
      }
      .padding(.horizontal, 30)
      VStack {
        HStack {
          ZStack {
            Rectangle()
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
              .foregroundStyle(.white)
            Image(systemSymbol: .commandCircleFill)
              .resizable()
              .frame(width: 60, height: 60)
              .foregroundStyle(quicklinkColor)
              .symbolRenderingMode(.hierarchical)
              .brightness(-brightness)
              .saturation(saturation)
          }
          Spacer()
          ZStack {
            Rectangle()
              .frame(width: 100, height: 100)
              .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
              .foregroundStyle(.black)
            Image(systemSymbol: .commandCircleFill)
              .resizable()
              .frame(width: 60, height: 60)
              .foregroundStyle(quicklinkColor)
              .symbolRenderingMode(.hierarchical)
              .brightness(brightness)
              .saturation(saturation)
          }
        }
        Spacer()
        SavedColorsListView()
        Group{
          Text("brightness: " + String(brightness).prefix(4)).lineLimit(1)
          Slider(value: $brightness, in: -3...3, step: 0.1)
          Text("saturation: " + String(saturation).prefix(4)).lineLimit(1)
          Slider(value: $saturation, in: 0...10, step: 0.1)
        }
        .padding(.horizontal, 20)
        HStack {
          SmallNavButton(systemSymbol: .sliderHorizontal2RectangleAndArrowTriangle2Circlepath, text: "Reset Sliders", color: .red, symbolLocation: .left)
            .onTapGesture {
              brightness = 0.3
              saturation = 2
            }
            .padding(10)
          LargeNavButton(text: "Clear Color List", color: .red)
            .onTapGesture {
              resetColorList()
            }
        }
        
          .padding(10)

        LargeNavButton(text: "Save Color", color: .blue)
          .onTapGesture {
            saveColor()
          }
          .padding(10)
      }
      .padding(.horizontal, 10)
    }
          .preferredColorScheme(isListDarkMode ? .dark : .light)
  }

  func saveColor() {
    savedColors.append(customColor(colorHex: quicklinkColor.toHex() ?? "", brightness: brightness, saturation: saturation))
  }
  func resetColorList() {
    savedColors.removeAll()
  }
  
}

struct ColorTesterView_Previews: PreviewProvider {
  static var previews: some View {
    ColorTesterView()
  }
}

struct SavedColorsListView: View {
  @AppStorage("savedColors") var savedColors = Settings.savedColors
  @Environment(\.colorScheme) var colorScheme
//  @Binding var isListDarkMode: Bool
  
  var body: some View {
    List {
      ForEach(savedColors, id: \.self) { color in
        HStack{
          Text(color.colorHex)
          Text("B: " + String(color.brightness).prefix(4)).lineLimit(1)
          Text("S: " + String(color.saturation).prefix(4)).lineLimit(1)
          Spacer()
          Image(systemName: CircleFillIcons().iconsList()[Int.random(in: 1..<CircleFillIcons().iconsList().count-1)])
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundStyle(Color(hex: color.colorHex) ?? .clear)
            .symbolRenderingMode(.hierarchical)
            .brightness(colorScheme == .light ? -color.brightness : color.brightness)
            .saturation(color.saturation)
        }
      }
    }
  }
}


struct AppearanceSwitcherButton: View {
  @AppStorage("savedColors") var savedColors = Settings.savedColors
  @Environment(\.colorScheme) var colorScheme
  @Binding var isListDarkMode: Bool
  
  var body: some View {
    Button{
      isListDarkMode.toggle()
    } label: {
      Image(systemSymbol: isListDarkMode ? .lightbulbSlash : .lightbulbFill)
        .font(.largeTitle)
        .foregroundStyle(.yellow)
        .padding(.trailing, 40)
    }
  }
}

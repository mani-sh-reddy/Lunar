//
//  CustomSymbols.swift
//  Lunar
//
//  Created by Mani on 04/11/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

class CustomSymbols {
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

  var hiddenPosts: some View {
    Image(systemSymbol: accentColorString == "Default" ? .lockRectangleOnRectangleFill : .lockRectangleOnRectangle)
      .foregroundStyle(accentColorString == "Default" ? .gray : accentColor)
  }

  var notificationsSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .bellBadgeFill : .bellBadge)
      .symbolRenderingMode(accentColorString == "Default" ? .multicolor : .monochrome)
      .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
  }

  var gesturesSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .handDrawFill : .handDraw)
      .symbolRenderingMode(.hierarchical)
      .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
  }

  var soundAndHapticsSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .speakerWave2Fill : .speakerWave2)
      .symbolRenderingMode(.hierarchical)
      .foregroundStyle(accentColorString == "Default" ? .pink : accentColor)
  }

  var composerSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .textBubbleFill : .textBubble)
      .symbolRenderingMode(accentColorString == "Default" ? .hierarchical : .monochrome)
      .foregroundStyle(accentColorString == "Default" ? .gray : accentColor)
  }

  var searchSettings: some View {
    Image(systemSymbol: .textMagnifyingglass)
      .foregroundStyle(accentColorString == "Default" ? .teal : accentColor)
  }

  var quicklinksSettings: some View {
    Image(systemSymbol: .link)
      .symbolRenderingMode(accentColorString == "Default" ? .multicolor : .monochrome)
      .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
  }

  var quicklinksSettingsDisabled: some View {
    Image(systemSymbol: .link)
      .foregroundStyle(accentColorString == "Default" ? .gray : accentColor)
  }

  var appIconSettings: some View {
    Image(systemSymbol: .appDashed)
      .foregroundStyle(accentColorString == "Default" ? .purple : accentColor)
  }

  var themeSettings: some View {
    Image(systemSymbol: .paintbrush)
      .foregroundStyle(accentColorString == "Default" ? .indigo : accentColor)
  }

  var layoutSettings: some View {
    Image(systemSymbol: .squareshapeControlhandlesOnSquareshapeControlhandles)
      .foregroundStyle(accentColorString == "Default" ? .mint : accentColor)
  }

  var privacyPolicySettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .lockDocFill : .lockDoc)
      .foregroundStyle(accentColorString == "Default" ? .green : accentColor)
  }

  var emailSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .paperplaneFill : .paperplane)
      .foregroundStyle(accentColorString == "Default" ? .blue : accentColor)
  }

  @ViewBuilder
  var githubSettings: some View {
    if accentColorString == "Default" {
      Image(asset: "GithubLogo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        .clipped()
        .foregroundStyle(accentColor)
    } else {
      Image(systemSymbol: .arrowTrianglePull)
        .foregroundStyle(accentColor)
    }
  }

  var additionalSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .shippingboxFill : .shippingbox)
      .foregroundStyle(accentColorString == "Default" ? .brown : accentColor)
  }

  var developmentSettings: some View {
    Image(systemSymbol: .wrenchAndScrewdriverFill)
      .foregroundStyle(accentColorString == "Default" ? .red : accentColor)
  }

  var lemmyGuide: some View {
    Image(systemSymbol: accentColorString == "Default" ? .bookClosedFill : .bookClosed)
      .foregroundStyle(accentColorString == "Default" ? .green : accentColor)
  }

  var appCacheTotalSize: some View {
    Image(systemSymbol: .externaldrive)
      .symbolRenderingMode(accentColorString == "Default" ? .multicolor : .monochrome)
      .foregroundStyle(accentColorString == "Default" ? .gray : .accentColor)
  }

  var appCacheLimit: some View {
    Image(systemSymbol: accentColorString == "Default" ? .externaldriveFill : .externaldriveBadgePlus)
      .symbolRenderingMode(accentColorString == "Default" ? .multicolor : .monochrome)
      .foregroundStyle(accentColorString == "Default" ? .gray : .accentColor)
  }

  var appCacheClearCache: some View {
    Image(systemSymbol: accentColorString == "Default" ? .externaldriveFillBadgeXmark : .externaldriveBadgeXmark)
      .symbolRenderingMode(accentColorString == "Default" ? .multicolor : .palette)
      .foregroundStyle(accentColorString == "Default" ? .gray : .red, Color.accentColor)
  }
}

import SwiftUI

struct test: View {
  var body: some View {
    List {
      CustomSymbols().lemmyGuide
      CustomSymbols().appCacheTotalSize
      CustomSymbols().appCacheLimit
      CustomSymbols().appCacheClearCache
      Text("")
      CustomSymbols().notificationsSettings
      CustomSymbols().gesturesSettings
      CustomSymbols().soundAndHapticsSettings
      CustomSymbols().composerSettings
      CustomSymbols().searchSettings
      CustomSymbols().quicklinksSettings
      CustomSymbols().appIconSettings
      CustomSymbols().themeSettings
      CustomSymbols().layoutSettings
      CustomSymbols().privacyPolicySettings
      CustomSymbols().emailSettings
      CustomSymbols().githubSettings
      CustomSymbols().additionalSettings
      CustomSymbols().developmentSettings
    }
    .font(.title)
  }
}

struct test_Previews: PreviewProvider {
  static var previews: some View {
    test()
  }
}

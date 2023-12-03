//
//  AllSymbols.swift
//  Lunar
//
//  Created by Mani on 04/11/2023.
//

import Defaults
import Foundation
import SFSafeSymbols
import SwiftUI

class AllSymbols {
  @Default(.accentColor) var accentColor
  @Default(.accentColorString) var accentColorString

  // MARK: - Context Menu and Swipe Action Icons

  var shareContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.arrowTriangleTurnUpRightCircle
  }

  var unsubscribeContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.heartSlashCircle
  }

  var hideContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.slashCircle
  }

  var upvoteContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.arrowUpCircle
  }

  var downvoteContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.arrowDownCircle
  }

  var goIntoContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.chevronForwardCircle
  }

  var replyContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.arrowshapeTurnUpLeftCircle
  }

  var minimiseContextIcon: SFSafeSymbols.SFSymbol {
    SFSafeSymbols.SFSymbol.arrowDownRightAndArrowUpLeftCircle
  }

  // MARK: - Home Screen Quick Actions Icons

  var feedQuickAction: UIApplicationShortcutIcon {
    UIApplicationShortcutIcon(systemSymbol: .rectangleOnRectangle)
  }

  var inboxQuickAction: UIApplicationShortcutIcon {
    UIApplicationShortcutIcon(systemSymbol: .envelope)
  }

  var accountQuickAction: UIApplicationShortcutIcon {
    UIApplicationShortcutIcon(systemSymbol: .personCropRectangle)
  }

  var searchQuickAction: UIApplicationShortcutIcon {
    UIApplicationShortcutIcon(systemSymbol: .rectangleAndTextMagnifyingglass)
  }

//  MARK: - Settings Icons

  var externalLinkArrow: some View {
    Image(systemSymbol: .arrowUpRightCircle)
      .foregroundStyle(.secondary)
      .opacity(0.5)
  }

  var externalMailArrow: some View {
    Image(systemSymbol: .envelopeCircle)
      .foregroundStyle(.secondary)
      .opacity(0.5)
  }

  var externalShareArrow: some View {
    Image(systemSymbol: .arrowUpCircle)
      .foregroundStyle(.secondary)
      .opacity(0.5)
  }

  var copyToClipboardHint: some View {
    Image(systemSymbol: .commandCircle)
      .foregroundStyle(.secondary)
      .opacity(0.5)
  }

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

  var shareLunarSettings: some View {
    Image(systemSymbol: accentColorString == "Default" ? .squareAndArrowUpFill : .squareAndArrowUp)
      .foregroundStyle(accentColorString == "Default" ? .yellow : accentColor)
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

  @ViewBuilder
  var matrixSettings: some View {
    if accentColorString == "Default" {
      Image(asset: "MatrixLogo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 25, height: 25)
        .clipped()
        .foregroundStyle(accentColor)
    } else {
      Image(systemSymbol: .bubbleLeft)
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

struct SettingsIconsView: View {
  var body: some View {
    List {
      AllSymbols().lemmyGuide
      AllSymbols().appCacheTotalSize
      AllSymbols().appCacheLimit
      AllSymbols().appCacheClearCache
      Text("")
      AllSymbols().notificationsSettings
      AllSymbols().gesturesSettings
      AllSymbols().soundAndHapticsSettings
      AllSymbols().composerSettings
      AllSymbols().searchSettings
      AllSymbols().quicklinksSettings
      AllSymbols().appIconSettings
      AllSymbols().themeSettings
      AllSymbols().layoutSettings
      AllSymbols().privacyPolicySettings
      AllSymbols().emailSettings
      AllSymbols().githubSettings
      AllSymbols().additionalSettings
      AllSymbols().developmentSettings
    }
    .font(.title)
  }
}

struct ContextIconsView: View {
  var body: some View {
    Circle().frame(width: 100, height: 100)
      .contextMenu(ContextMenu(menuItems: {
        Button {} label:
          { Label("shareContextIcon", systemSymbol: AllSymbols().shareContextIcon) }
        Button {} label:
          { Label("unsubscribeContextIcon", systemSymbol: AllSymbols().unsubscribeContextIcon) }
        Button {} label:
          { Label("hideContextIcon", systemSymbol: AllSymbols().hideContextIcon) }
        Button {} label:
          { Label("minimiseContextIcon", systemSymbol: AllSymbols().minimiseContextIcon) }
        Button {} label:
          { Label("upvoteContextIcon", systemSymbol: AllSymbols().upvoteContextIcon) }
        Button {} label:
          { Label("downvoteContextIcon", systemSymbol: AllSymbols().downvoteContextIcon) }
        Button {} label:
          { Label("goIntoContextIcon", systemSymbol: AllSymbols().goIntoContextIcon) }
        Button {} label:
          { Label("replyContextIcon", systemSymbol: AllSymbols().replyContextIcon) }
      }))
  }
}

#Preview {
  SettingsIconsView()
}

#Preview {
  ContextIconsView()
}

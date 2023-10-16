//
//  URLInputViews.swift
//  Lunar
//
//  Created by Mani on 16/10/2023.
//

import Foundation
import NukeUI
import SwiftUI

// MARK: - URLInputView

struct URLInputView: View {
  @Binding var siteMetadata: SiteMetadataObject
  @Binding var userInputURL: String

  var body: some View {
    HStack(spacing: 1) {
      Text("https://")
        .foregroundStyle(userInputURL.isEmpty ? .gray : .primary)
      TextField(text: $userInputURL) {}
        .keyboardType(.URL)
        .autocorrectionDisabled()
        .textInputAutocapitalization(.never)
        .font(.body)

      if let image = siteMetadata.image {
        Spacer()
        LazyImage(url: URL(string: image)) { state in
          if let image = state.image {
            image
              .resizable()
              .frame(width: 30, height: 30)
              .aspectRatio(contentMode: .fill)
              .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
          }
        }
      }
    }
  }
}

// MARK: - URLInputFooterView

struct URLInputFooterView: View {
  @Binding var siteMetadata: SiteMetadataObject
  @Binding var expandSiteMetadata: Bool

  var body: some View {
    VStack {
      HStack {
        if let title = siteMetadata.title {
          Text(title.prefix(50)).bold()
            .lineLimit(1)
        }
        if !expandSiteMetadata {
          if let description = siteMetadata.description {
            Text(description)
              .lineLimit(1)
          }
        }

        Spacer()
        if let description = siteMetadata.description {
          if let title = siteMetadata.title {
            if description.count + title.count > 30 {
              Button {
                expandSiteMetadata.toggle()
              } label: {
                Image(systemSymbol: expandSiteMetadata ? .chevronDownCircle : .chevronRightCircleFill)
                  .font(.footnote)
                  .foregroundStyle(.gray)
              }
            }
          }
        }
        Text(" ")
      }
      if expandSiteMetadata {
        if let description = siteMetadata.description {
          Text(description)
        }
      }
    }
  }
}

// MARK: - URLInputDebounceLogic

struct URLInputDebounceLogic {
  @Binding var siteMetadata: SiteMetadataObject
  @Binding var userInputURL: String

  var newValue: String

  func run() {
    if newValue.hasPrefix("https://") {
      userInputURL.removeFirst(8) // Remove "https://" if it has it
    }
    if (RegexPatterns.matchAnyURL?.firstMatch(in: newValue, options: [], range: NSRange(location: 0, length: newValue.utf16.count))) != nil {
      PostSiteMetadataFetcher(urlString: "https://\(newValue)").fetchPostSiteMetadata { response in
        siteMetadata = response ?? SiteMetadataObject(
          title: nil,
          description: nil,
          image: nil
        )
        print(response?.description as Any)
        print(response?.image as Any)
        print(response?.title as Any)
      }
    }
  }
}

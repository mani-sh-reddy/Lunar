//
//  AttributedStringExtension.swift
//  Lunar
//
//  Created by Mani on 16/09/2023.
//

import Foundation

extension AttributedString {
  init(styledMarkdown markdownString: String) throws {
    var output = try AttributedString(
      markdown: markdownString,
      options: .init(
        allowsExtendedAttributes: true,
        interpretedSyntax: .inlineOnlyPreservingWhitespace,
        failurePolicy: .returnPartiallyParsedIfPossible
      ),
      baseURL: nil
    )

    for (intentBlock, intentRange) in output.runs[AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self].reversed() {
      guard let intentBlock else { continue }
      for intent in intentBlock.components {
        switch intent.kind {
        case let .header(level: level):
          switch level {
          case 1:
            output[intentRange].font = .system(.title).bold()
          case 2:
            output[intentRange].font = .system(.title2).bold()
          case 3:
            output[intentRange].font = .system(.title3).bold()
          default:
            break
          }
        default:
          break
        }
      }

      if intentRange.lowerBound != output.startIndex {
        output.characters.insert(contentsOf: "\n", at: intentRange.lowerBound)
      }
    }

    self = output
  }
}

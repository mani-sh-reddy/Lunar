////
////  AttributedStringExtension.swift
////  Lunar
////
////  https://github.com/frankrausch/AttributedStringStyledMarkdown
////
//
// import MarkdownUI
// import SwiftUI
// import UIKit
//
// private enum MarkdownStyledBlock: Equatable {
//  case generic
//  case headline(Int)
//  case paragraph
//  case unorderedListElement
//  case orderedListElement(Int)
//  case blockquote
//  case code(String?)
//  case horizontalRule
// }
//
//// MARK: -
//
// extension AttributedString {
//  init(
//    styledMarkdown markdownString: String,
//    fontSize: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize
//  ) throws {
//    var s = try AttributedString(
//      markdown: markdownString,
//      options: .init(
//        allowsExtendedAttributes: true,
//        interpretedSyntax: .full,
//        failurePolicy: .returnPartiallyParsedIfPossible,
//        languageCode: "en"
//      ),
//      baseURL: nil
//    )
//
//    // Looking at the AttributedString’s raw structure helps with understanding the following code.
////    print(s)
//
//    // MARK: - Base Formatting
//
//    s.font = .body
//    s.paragraphStyle = AttributedStringStyles().defaultParagraphStyle
//    s.foregroundColor = .label
//
//    // MARK: - Inline
//
//    let inlineIntents: [InlinePresentationIntent] = [
//      .emphasized,
//      .stronglyEmphasized,
//      .code,
//      .strikethrough,
//      .softBreak,
//      .lineBreak,
//      .inlineHTML,
//      .blockHTML
//    ]
//
//    for inlineIntent in inlineIntents {
//      var sourceAttributeContainer = AttributeContainer()
//      sourceAttributeContainer.inlinePresentationIntent = inlineIntent
//
//      var targetAttributeContainer = AttributeContainer()
//      switch inlineIntent {
//      case .emphasized:
//        targetAttributeContainer.font = .body.italic()
//      case .stronglyEmphasized:
//        targetAttributeContainer.font = .body.bold()
//      case .code:
//        targetAttributeContainer.font = .body.monospaced()
//        targetAttributeContainer.backgroundColor = .secondarySystemBackground
//      case .strikethrough:
//        targetAttributeContainer.strikethroughStyle = .single
//      case .softBreak:
//        break // TODO: Implement
//      case .lineBreak:
//        break // TODO: Implement
//      case .inlineHTML:
//        targetAttributeContainer.foregroundColor = .blue
//      case .blockHTML:
//        targetAttributeContainer.foregroundColor = .blue
//      default:
//        break
//      }
//      s = s.replacingAttributes(sourceAttributeContainer, with: targetAttributeContainer)
//    }
//
//    // MARK: - Blocks
//
//    var previousListID = 0
//
//    for (intentBlock, intentRange) in s.runs[
//      AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self
//    ].reversed() {
//      guard let intentBlock = intentBlock else { continue }
//
//      var block: MarkdownStyledBlock = .generic
//      var currentElementOrdinal = 0
//
//      var currentListID = 0
//
//      for intent in intentBlock.components {
//        switch intent.kind {
//        case .paragraph:
//          if block == .generic {
//            block = .paragraph
//          }
//        case .header(level: let level):
//          block = .headline(level)
//        case .orderedList:
//          block = .orderedListElement(currentElementOrdinal)
//          currentListID = intent.identity
//        case .unorderedList:
//          block = .unorderedListElement
//          currentListID = intent.identity
//        case .listItem(ordinal: let ordinal):
//          currentElementOrdinal = ordinal
//          if block != .unorderedListElement {
//            block = .orderedListElement(ordinal)
//          }
//        case .codeBlock(languageHint: let languageHint):
//          block = .code(languageHint)
//        case .blockQuote:
//          block = .blockquote
//        case .thematicBreak:
//          block = .horizontalRule
//        case .table(columns: _):
//          break
//        case .tableHeaderRow:
//          break
//        case .tableRow(rowIndex: _):
//          break
//        case .tableCell(columnIndex: _):
//          break
//        @unknown default:
//          break
//        }
//      }
//
//      switch block {
//      case .generic:
//        assertionFailure(intentBlock.debugDescription)
//      case .headline(let level):
//        switch level {
//        case 1:
//          s[intentRange].font = .title.bold()
//        case 2:
//          s[intentRange].font = .title2.bold()
//        case 3:
//          s[intentRange].font = .title3.bold()
//        default:
//          // TODO: Handle H4 to H6
//          s[intentRange].font = .headline
//        }
//      case .paragraph:
//        break
//      case .unorderedListElement:
//        s.characters.insert(contentsOf: "  •  ", at: intentRange.lowerBound)
//        s[intentRange].paragraphStyle = previousListID == currentListID ? AttributedStringStyles().listParagraphStyle : AttributedStringStyles().lastElementListParagraphStyle
//      case .orderedListElement(let ordinal):
//        s.characters.insert(contentsOf: "  \(ordinal).\t", at: intentRange.lowerBound)
//        s[intentRange].paragraphStyle = previousListID == currentListID ? AttributedStringStyles().listParagraphStyle : AttributedStringStyles().lastElementListParagraphStyle
//      case .blockquote:
//        s.characters.insert(contentsOf: "\t\t", at: intentRange.lowerBound)
//        s[intentRange].foregroundColor = .gray
////        s[intentRange].paragraphStyle = AttributedStringStyles().defaultParagraphStyle
//      case .code:
//        s[intentRange].font = .monospacedSystemFont(ofSize: 13, weight: .regular)
//        s[intentRange].paragraphStyle = AttributedStringStyles().codeParagraphStyle
//      case .horizontalRule:
//        s[intentRange].foregroundColor = .secondary
//      }
//
//      // Remember the list ID so we can check if it’s identical in the next block
//      previousListID = currentListID
//
//      // MARK: Add line breaks to separate blocks
//
//      if intentRange.lowerBound != s.startIndex {
//        s.characters.insert(contentsOf: "\n", at: intentRange.lowerBound)
//      }
//    }
//
//    self = s
//  }
// }
//
// class AttributedStringStyles {
//  fileprivate let defaultParagraphStyle: NSParagraphStyle = {
//    var paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.paragraphSpacing = 10.0
//    paragraphStyle.minimumLineHeight = 20.0
//    return paragraphStyle
//  }()
//
//  fileprivate let listParagraphStyle: NSMutableParagraphStyle = {
//    var paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 20)]
//    paragraphStyle.headIndent = 20
//    paragraphStyle.minimumLineHeight = 20.0
//    return paragraphStyle
//  }()
//
//  fileprivate let lastElementListParagraphStyle: NSMutableParagraphStyle = {
//    var paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 20)]
//    paragraphStyle.headIndent = 20
//    paragraphStyle.minimumLineHeight = 20.0
//    paragraphStyle.paragraphSpacing = 20.0 // The last element in a list needs extra paragraph spacing
//    return paragraphStyle
//  }()
//
//  fileprivate let codeParagraphStyle: NSParagraphStyle = {
//    var paragraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.minimumLineHeight = 20.0
//    paragraphStyle.firstLineHeadIndent = 20
//    paragraphStyle.headIndent = 20
//    return paragraphStyle
//  }()
// }
//
//// MARK: - Testing
//
// struct AttributedStringView: View {
//  let content = MarkdownContent("You can try **CommonMark** [here](https://spec.commonmark.org/dingus/).")
//  var body: some View {
//    List {
//      Markdown { """
//      Blockquote:
//      > Blockquote Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna.
//      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
//
//      """ }
//      Text(try! AttributedString(styledMarkdown: """
//      Image:
//
//      ![Image](https://lemmy.world/pictrs/image/3106bed3-c3da-4009-82ea-1793d361724d.jpeg)
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Italic:
//      *Italic*
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Bold:
//      **Bold**
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Heading 1:
//      # Heading 1
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Heading 2:
//      ## Heading 2
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Link:
//      [Link](http://a.com)
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Blockquote:
//      > Blockquote Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
//
//      Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
//
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      List:
//      * List
//      * List
//      * List
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Numbered List:
//      1. One
//      2. Two
//      3. Three
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Horizontal Rule:
//
//      ---
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Inline code with backticks:
//      `Inline code` with backticks
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Code Block:
//      ```
//      # code block
//      print '3 backticks or'
//      print 'indent 4 spaces'
//      ```
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Spoiler:
//      ::: spoiler hidden or nsfw stuff
//      a bunch of spoilers here
//      :::
//      """))
//      Text(try! AttributedString(styledMarkdown: """
//      Some -subscript- text
//      Some ^superscript^ text
//      """))
//    }
//    .listStyle(.grouped)
//  }
// }
//
// struct AttributedStringView_Previews: PreviewProvider {
//  static var previews: some View {
//    AttributedStringView()
//  }
// }

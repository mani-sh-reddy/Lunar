////
////  ExpandableTextBox.swift
////  Lunar
////
////  Created by Mani on 15/08/2023.
////
//
// import Defaults
// import Foundation
// import MarkdownUI
// import SFSafeSymbols
// import SwiftUI
//
// struct ExpandableTextBox: View {
//  @State private var expanded: Bool = false
//  @State private var truncated: Bool = false
////  private var text: LocalizedStringKey
//  var text: String
//  var lineLimit = 3
//
//  let haptics = UIImpactFeedbackGenerator(style: .soft)
//
////  init(_ text: LocalizedStringKey) {
////    self.text = text
////  }
//
//  var body: some View {
//    VStack(alignment: .leading) {
////      Text(text)
//      Markdown { text }
//        .lineLimit(expanded ? nil : lineLimit)
//        .background(
//          Text(text).lineLimit(lineLimit)
//            .background(
//              GeometryReader { displayedGeometry in
//                ZStack {
//                  Markdown { text }
//                    .background(
//                      GeometryReader { fullGeometry in
//                        Color.clear.onAppear {
//                          truncated = fullGeometry.size.height > displayedGeometry.size.height
//                        }
//                      })
//                }
//                .frame(height: .greatestFiniteMagnitude)
//              }
//            )
//            .hidden()
//        )
//
//      if truncated { toggleButton }
//    }
//  }
//
//  var toggleButton: some View {
//    HStack {
//      Spacer()
//      ReactionButton(
//        text: expanded ? "Show less" : "Show more",
//        icon: expanded
//          ? SFSafeSymbols.SFSymbol.arrowTurnLeftUp
//          : SFSafeSymbols.SFSymbol.arrowTurnLeftDown,
//        color: Color.blue,
//        textSize: Font.caption,
//        iconSize: Font.caption,
//        active: $expanded,
//        opposite: .constant(false)
//      )
//      .highPriorityGesture(
//        TapGesture().onEnded {
//          haptics.impactOccurred(intensity: 0.5)
//          expanded.toggle()
//        }
//      )
//      Spacer()
//    }
//  }
// }

////
////  ReactionButtonView.swift
////  Lunar
////
////  Created by Mani on 19/08/2023.
////
//
// import Foundation
// import SwiftUI
//
// struct ReactionButtonView: View {
//  var text: String
//  var icon: String
//  var color: Color
//
//  @Binding var active: Bool
//  @Binding var opposite: Bool
//
//  let haptics = UIImpactFeedbackGenerator(style: .rigid)
//
//  var body: some View {
//    Button {
//      active.toggle()
//      opposite = false
//      haptics.impactOccurred()
//    } label: {
//      HStack {
//        Image(systemName: icon)
//        Text(text)
//          .font(.subheadline)
//      }
//      .foregroundStyle(active ? Color.white : color)
//      .symbolRenderingMode(
//        active ? SymbolRenderingMode.monochrome : SymbolRenderingMode.hierarchical
//      )
//    }
//    .buttonStyle(BorderlessButtonStyle())
//    .padding(5).padding(.trailing, 3)
//    .background(active ? color.opacity(0.75) : .secondary.opacity(0.1), in: Capsule())
//    .padding(.top, 3)
//  }
// }

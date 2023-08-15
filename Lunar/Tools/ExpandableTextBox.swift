//
//  ExpandableTextBox.swift
//  Lunar
//
//  Created by Mani on 15/08/2023.
//

import Foundation
import SwiftUI

struct ExpandableTextBox: View {
  @State private var expanded: Bool = false
  @State private var truncated: Bool = false
  private var text: String
  var lineLimit = 3
  
  init(_ text: String) {
    self.text = text
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(text)
        .lineLimit(expanded ? nil : lineLimit)
        .background(
          Text(text).lineLimit(lineLimit)
            .background(GeometryReader { displayedGeometry in
              ZStack {
                Text(self.text)
                  .background(GeometryReader { fullGeometry in
                    
                    Color.clear.onAppear {
                      self.truncated = fullGeometry.size.height > displayedGeometry.size.height
                    }
                  })
              }
              .frame(height: .greatestFiniteMagnitude)
            })
            .hidden()
        )
      
      if truncated { toggleButton }
    }
  }
  
  var toggleButton: some View {
//    Button(action: { self.expanded.toggle() }) {
//      Text(self.expanded ? "Show less" : "Show more")
//        .font(.caption)
//    }
    HStack{
      Spacer()
      ReactionButton(
        text: self.expanded ? "Show less" : "Show more",
        icon: self.expanded ? "arrow.down.and.line.horizontal.and.arrow.up" : "arrow.up.and.line.horizontal.and.arrow.down",
        color: Color.blue,
        textSize: Font.caption,
        iconSize: Font.caption,
        active: self.$expanded,
        opposite: .constant(false)
      )
      .onTapGesture {
        withAnimation(.smooth) {
          self.expanded.toggle()
        }
      }
    }
    
  }
}

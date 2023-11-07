//
//  DragabbleView.swift
//  Lunar
//
//  Created by Mani on 07/11/2023.
//

import Foundation
import SwiftUI

enum DragState {
  case inactive
  case pressing
  case dragging(translation: CGSize)

  var translation: CGSize {
    switch self {
    case .inactive, .pressing:
      .zero
    case let .dragging(translation):
      translation
    }
  }

  var isPressing: Bool {
    switch self {
    case .pressing, .dragging:
      true
    case .inactive:
      false
    }
  }
}

struct DraggableView<Content>: View where Content: View {
  @GestureState private var dragState = DragState.inactive
  @State private var position = CGSize.zero

  let hapticsHeavy = UIImpactFeedbackGenerator(style: .heavy)
  let hapticsRigid = UIImpactFeedbackGenerator(style: .rigid)

  var content: () -> Content

  var body: some View {
    content()
      .opacity(dragState.isPressing ? 0.7 : 1.0)
      .scaleEffect(dragState.isPressing ? 1.5 : 1.0)
      .padding(.bottom, dragState.isPressing ? 20 : nil)
      .offset(x: position.width + dragState.translation.width, y: position.height + dragState.translation.height)
//      .animation(Animation.easeInOut(duration: 0.5), value: position)
      .gesture(
        LongPressGesture(minimumDuration: 0.5)
          .sequenced(before: DragGesture())
          .updating($dragState, body: { value, state, _ in
            switch value {
            case .first(true):
              state = .pressing
            case .second(true, let drag):
              hapticsRigid.impactOccurred(intensity: 0.5)
              state = .dragging(translation: drag?.translation ?? .zero)
            default:
              break
            }

          })
          .onEnded { value in
            hapticsHeavy.impactOccurred()
            guard case .second(true, let drag?) = value else {
              return
            }
            position.height += drag.translation.height
            position.width += drag.translation.width
          }
      )
  }
}

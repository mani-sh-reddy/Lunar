//
//  ViewExtension.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

import Combine
import Foundation
import SwiftUI
import UIKit

extension View {
  func hapticFeedbackOnTap(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
    onTapGesture {
      let impact = UIImpactFeedbackGenerator(style: style)
      impact.impactOccurred()
    }
  }

  //  func hapticNotificationFeedbackOnTap(style: UINotificationFeedbackGenerator.FeedbackType)
//    -> some View
  //  {
//    onTapGesture {
//      let haptic = UINotificationFeedbackGenerator()
//      haptic.notificationOccurred(style)
//    }
  //  }

  func onDebouncedChange<V>(
    of binding: Binding<V>,
    debounceFor dueTime: TimeInterval,
    perform action: @escaping (V) -> Void
  ) -> some View where V: Equatable {
    modifier(ListenDebounce(binding: binding, dueTime: dueTime, action: action))
  }

  /// Conditional Modifier
  /// **Usage:**
  /// ```
  /// .if(!debugModeEnabled) {_ in
  ///     EmptyView()
  /// }
  /// ```
  @ViewBuilder
  func `if`(_ conditional: Bool, content: (Self) -> some View) -> some View {
    if conditional {
      content(self)
    } else {
      self
    }
  }
}

private struct ListenDebounce<Value: Equatable>: ViewModifier {
  @Binding
  var binding: Value
  @StateObject
  var debounceSubject: ObservableDebounceSubject<Value, Never>
  let action: (Value) -> Void
  init(binding: Binding<Value>, dueTime: TimeInterval, action: @escaping (Value) -> Void) {
    _binding = binding
    _debounceSubject = .init(wrappedValue: .init(dueTime: dueTime))
    self.action = action
  }

  func body(content: Content) -> some View {
    content
      .onChange(of: binding) { value in
        debounceSubject.send(value)
      }
      .onReceive(debounceSubject) { value in
        action(value)
      }
  }
}

private final class ObservableDebounceSubject<
  Output: Equatable,
  Failure
>: Subject,
  ObservableObject
  where Failure: Error
{
  private let passthroughSubject = PassthroughSubject<Output, Failure>()
  let dueTime: TimeInterval
  init(dueTime: TimeInterval) {
    self.dueTime = dueTime
  }

  func send(_ value: Output) {
    passthroughSubject.send(value)
  }

  func send(completion: Subscribers.Completion<Failure>) {
    passthroughSubject.send(completion: completion)
  }

  func send(subscription: Subscription) {
    passthroughSubject.send(subscription: subscription)
  }

  func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    passthroughSubject
      .removeDuplicates()
      .debounce(for: .init(dueTime), scheduler: RunLoop.main)
      .receive(subscriber: subscriber)
  }
}

public extension View {
  // This function changes our View to UIView, then calls another function
  // to convert the newly-made UIView to a UIImage.
  func asUIImage() -> UIImage {
    let controller = UIHostingController(rootView: self)
    // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
    controller.view.backgroundColor = .black
    controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
    UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .filter(\.isKeyWindow)
      .first!.rootViewController?.view.addSubview(controller.view) // skipcq: SW-W1023
    let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
    controller.view.bounds = CGRect(origin: .zero, size: size)
    controller.view.sizeToFit()
    // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
    let image = controller.view.asUIImage()
    controller.view.removeFromSuperview()
    return image
  }
}

public extension UIView {
  // This is the function to convert UIView to UIImage
  func asUIImage() -> UIImage {
    let format = UIGraphicsImageRendererFormat()
    format.scale = 1
    let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}

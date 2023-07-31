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

    func hapticNotificationFeedbackOnTap(style: UINotificationFeedbackGenerator.FeedbackType) -> some View {
        onTapGesture {
            let haptic = UINotificationFeedbackGenerator()
            haptic.notificationOccurred(style)
        }
    }

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

private final class ObservableDebounceSubject<Output: Equatable, Failure>: Subject, ObservableObject where Failure: Error {
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

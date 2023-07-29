//
//  ViewExtension.swift
//  Lunar
//
//  Created by Mani on 24/07/2023.
//

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

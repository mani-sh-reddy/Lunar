//
//  TextExtension.swift
//  Lunar
//
//  Created by Mani on 29/07/2023.
//

import Foundation
import SwiftUI

extension Text {
    func booleanColor(bool: Bool) -> some View {
        if bool == true {
            return foregroundColor(.green)
        }
        return foregroundColor(.red)
    }
}

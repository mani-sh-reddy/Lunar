//
//  AppResetButton.swift
//  Lunar
//
//  Created by Mani on 01/08/2023.
//

import SwiftUI

struct AppResetButton: View {
    @State private var showConfirmation: Bool = false
    @State private var isLoading: Bool = false
    @State private var isClicked: Bool = false
    @State private var confirmationOpacity: Double = 0

    private var notificationHaptics = UINotificationFeedbackGenerator()

    var body: some View {
        Section {
            Button(role: .destructive, action: {
                showConfirmation = true
            }) {
                Label {
                    if isLoading {
                        ProgressView()
                    } else {
                        Text("Reset App")
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    ZStack(alignment: .trailing) {
                        if isClicked {
                            Group {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title2).opacity(confirmationOpacity)
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.white)
                            }.onAppear {
                                let animation = Animation.smooth(duration: 2)
                                confirmationOpacity = 1
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isClicked = false
                                    withAnimation(animation) {
                                        confirmationOpacity = 0
                                    }
                                }
                            }
                        }
                    }
                } icon: {
                    Image(systemName: "exclamationmark.octagon.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .symbolRenderingMode(.hierarchical)
                }.onTapGesture {
                    showConfirmation = true
                }
            }
            .hapticFeedbackOnTap(style: .rigid)
            .listRowBackground(Color.red)
            .confirmationDialog("Clear user defaults and reset app", isPresented: $showConfirmation) {
                Button(role: .destructive, action: {
                    showConfirmation = true
                    isLoading = true
                    notificationHaptics.notificationOccurred(.success)
                    isClicked = true

                    if let bundleID = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: bundleID)
                        UserDefaults.standard.synchronize()
                    }

                    isLoading = false
                    showConfirmation = false
                }) {
                    Text("Confirm Reset")
                }
            }
        }
    }
}

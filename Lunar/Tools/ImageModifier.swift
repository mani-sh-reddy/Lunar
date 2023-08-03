//
//  ImageModifier.swift
//  Lunar
//
//  Created by Mani on 26/07/2023.
//

import Foundation
import SwiftUI
import UIKit

struct ImageModifier: ViewModifier {
    @AppStorage("debugModeEnabled") var debugModeEnabled = Settings.debugModeEnabled

    private var contentSize: CGSize
    private var min: CGFloat = 1.0
    private var max: CGFloat = 5.0
    @State var currentScale: CGFloat = 1.0
    @State var reader: ScrollViewProxy?

    @Binding var showingPopover: Bool // Declare showingPopover as a @Binding parameter

    init(contentSize: CGSize, showingPopover: Binding<Bool>) {
        self.contentSize = contentSize
        _showingPopover = showingPopover
    }

    var doubleTapGesture: some Gesture {
        TapGesture(count: 2).onEnded {
            if currentScale <= min { currentScale = 2 } else
            if currentScale > 1 { currentScale = min } else {
                currentScale = ((max - min) * 0.5 + min) < currentScale ? max : min
            }
            reader?.scrollTo(24, anchor: .center)
        }
    }

    func body(content: Content) -> some View {
        ScrollViewReader { reader in
            ScrollView([.horizontal, .vertical]) {
                /// FIX: Janky workaround to get the image in the center of the frame on appear

                ZStack {
                    content.frame(alignment: .center).border(debugModeEnabled ? Color.blue : Color.clear, width: 5)
                        //                .frame(width: contentSize.width, height: contentSize.height, alignment: .center)
                        .frame(width: contentSize.width * 2, height: contentSize.height * 2)
                        .scaleEffect(CGSize(width: 0.9, height: 0.9))
                        .border(debugModeEnabled ? Color.red : Color.clear, width: 5)
                        .modifier(PinchToZoom(minScale: min, maxScale: max, scale: $currentScale))
                    HStack(spacing: 20) {
                        ForEach(0 ..< 20) { j in
                            Circle().frame(width: debugModeEnabled ? 10 : 1).id(j).foregroundStyle(debugModeEnabled ? Color.green : Color.clear)
                        }
                    }
                    VStack(spacing: 10) {
                        ForEach(1 ..< 50) { i in
                            Circle().frame(width: debugModeEnabled ? 10 : 1).id(i).foregroundStyle(debugModeEnabled ? Color.yellow : Color.clear) // << here !!
                        }
                    }
                }

            }.task {
                DispatchQueue.main.async {
                    self.reader = reader
                    reader.scrollTo(24, anchor: .center)
                }
            }
        }
        .gesture(doubleTapGesture)
        .animation(.easeInOut, value: currentScale)
    }
}

class PinchZoomView: UIView {
    let minScale: CGFloat
    let maxScale: CGFloat
    var isPinching: Bool = false
    var scale: CGFloat = 1.0
    let scaleChange: (CGFloat) -> Void

    init(minScale: CGFloat,
         maxScale: CGFloat,
         currentScale: CGFloat,
         scaleChange: @escaping (CGFloat) -> Void)
    {
        self.minScale = minScale
        self.maxScale = maxScale
        scale = currentScale
        self.scaleChange = scaleChange
        super.init(frame: .zero)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(gesture:)))
        pinchGesture.cancelsTouchesInView = false
        addGestureRecognizer(pinchGesture)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    @objc private func pinch(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            isPinching = true

        case .changed, .ended:
            if gesture.scale <= minScale {
                scale = minScale
            } else if gesture.scale >= maxScale {
                scale = maxScale
            } else {
                scale = gesture.scale
            }
            scaleChange(scale)
        case .cancelled, .failed:
            isPinching = false
            scale = 1.0
        default:
            break
        }
    }
}

struct PinchZoom: UIViewRepresentable {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @Binding var isPinching: Bool

    func makeUIView(context _: Context) -> PinchZoomView {
        let pinchZoomView = PinchZoomView(minScale: minScale, maxScale: maxScale, currentScale: scale, scaleChange: { scale = $0 })
        return pinchZoomView
    }

    func updateUIView(_: PinchZoomView, context _: Context) {}
}

struct PinchToZoom: ViewModifier {
    let minScale: CGFloat
    let maxScale: CGFloat
    @Binding var scale: CGFloat
    @State var anchor: UnitPoint = .center
    @State var isPinching: Bool = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(scale, anchor: anchor)
            .animation(.spring(), value: isPinching)
            .gesture(DragGesture()
                .onChanged { _ in
                    // Set the anchor to the center when zooming
                    anchor = .center
                }
                .onEnded { _ in
                    // Reset the anchor after the drag gesture ends
                    anchor = .center
                }
            )
            .gesture(MagnificationGesture()
                .onChanged { scale in
                    // Update the scale
                    self.scale = scale
                }
            )
            .overlay(PinchZoom(minScale: minScale, maxScale: maxScale, scale: $scale, isPinching: $isPinching))
    }
}

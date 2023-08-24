//
//  SplashScreenView.swift
//  Lunar
//
//  Created by Mani on 27/07/2023.
//

import SwiftUI

struct SplashScreen: View {
  @State private var logoScale: CGFloat = 0.1
  @State private var logoOpacity: Double = 0
  @State private var logoRotationAngle: Angle = .degrees(0)
  @State private var showFeedView = false

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(
          colors: [
            Color("AppBlue"),
            Color("AppDarkBlue"),
          ]), startPoint: .topLeading, endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      Image("LunarLogo")
        .resizable()
        .scaledToFit()
        .padding(50)
        .shadow(color: .black, radius: 100, x: 20, y: 20)
        .scaleEffect(logoScale)
        .opacity(logoOpacity)
    }
    .onAppear {
      withAnimation(.easeInOut(duration: 1)) {
        logoScale = 1.0
      }
      withAnimation(Animation.easeInOut(duration: 1.0).delay(0.5)) {
        logoOpacity = 1.0
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        withAnimation(.easeOut(duration: 1)) {
          showFeedView = true
        }
      }
    }
    .fullScreenCover(isPresented: $showFeedView) {
      ContentView()
    }
  }
}

struct SplashScreen_Previews: PreviewProvider {
  static var previews: some View {
    SplashScreen()
  }
}

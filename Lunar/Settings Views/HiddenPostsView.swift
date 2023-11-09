//
//  HiddenPostsView.swift
//  Lunar
//
//  Created by Mani on 09/11/2023.
//

import SwiftUI

struct HiddenPostsView: View {
  @StateObject var appContext = Biometrics()

  var body: some View {
    ZStack {
      if appContext.appUnlocked {
        Text("Hello, World!")
          .animation(.default)
          .transition(.move(edge: .bottom))
      } else {
        FaceIDLoginView(appContext: appContext)
          .animation(.default, value: 1)
          .transition(.move(edge: .top))
      }
    }
  }
}

#Preview {
  HiddenPostsView()
}

struct FaceIDLoginView: View {
  @ObservedObject var appContext: Biometrics

  var body: some View {
    VStack(spacing: 24) {
      Image(systemName: "faceid")
        .resizable()
        .frame(width: 150, height: 150)

      Button(action: {
        appContext.requestBiometricUnlock()
      }, label: {
        HStack {
          Spacer()
          Text("Login now")
            .fontWeight(.bold)
          Spacer()
        }
        .padding(10)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
      })
    }
    .padding()
  }
}

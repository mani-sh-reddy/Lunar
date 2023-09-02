//
//  NewWelcomeScreen.swift
//  Lunar
//
//  Created by Mani on 03/09/2023.
//

import SwiftUI

struct NewWelcomeScreen: View {
  var body: some View {
    VStack {
      Text("Welcome to Lunar")
        .bold()
        .font(.largeTitle)
        .lineLimit(3)
        .frame(width: 240)
//        .clipped()
        .multilineTextAlignment(.center)
        .padding(.top, 82)
        .padding(.bottom, 52)
      VStack(spacing: 28) {
        ForEach(0..<3) { _ in // Replace with your data model here
          HStack {
            Image(systemName: "square.and.arrow.up")
              .foregroundColor(.blue)
              .font(.title)
              .frame(width: 60, height: 50)
              .clipped()
            VStack(alignment: .leading, spacing: 3) {
              Text("Collaborate in Messages")
                .font(.footnote.bold())
              Text("Easily share, discuss, and see updates about your presentation.")
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
          }
        }
      }
      HStack(alignment: .firstTextBaseline) {
        Text("Complete feature list")
        Image(systemName: "chevron.forward")
          .imageScale(.small)
      }
      .padding(.top, 32)
      .foregroundColor(.blue)
      .font(.subheadline)
      Spacer()
      Text("Continue")
        .font(.callout.bold())
        .padding()
        .frame(maxWidth: .infinity)
        .clipped()
        .foregroundColor(.white)
        .background(.blue)
        .mask { RoundedRectangle(cornerRadius: 16, style: .continuous) }
        .padding(.bottom, 60)
    }
    .frame(maxWidth: .infinity)
    .clipped()
    .padding(.bottom, 0)
    .padding(.horizontal, 29)
  }
}

struct NewWelcomeScreen_Previews: PreviewProvider {
  static var previews: some View {
    NewWelcomeScreen()
  }
}

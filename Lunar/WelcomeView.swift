//
//  NewWelcomeScreen.swift
//  Lunar
//
//  Created by Mani on 03/09/2023.
//

import SwiftUI

struct WelcomeView: View {
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen

  @State var currentPage = 0

  let welcomeScreenInfo = WelcomeScreenInfo()
  let haptics = UIImpactFeedbackGenerator(style: .soft)

  var body: some View {
    VStack {
      TabView(selection: $currentPage) {
        ForEach(welcomeScreenInfo.info.indices, id: \.self) { index in
          ScrollView {
            WelcomeScreenCard(
              currentPage: $currentPage,
              info: welcomeScreenInfo.info[index],
              count: welcomeScreenInfo.info.count
            )
            .tag(index)
            Spacer()
            Rectangle().frame(height: 100).foregroundStyle(.clear)
          }
          .padding(.bottom, 70)
          
        }
      }
      .padding(.vertical, 20)
      .tabViewStyle(.page)
      .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))

      Button {
        if currentPage >= 3 {
          haptics.impactOccurred()
          showWelcomeScreen = false
        } else {
          haptics.impactOccurred()
          withAnimation(.bouncy) {
            currentPage += 1
          }
        }
      } label: {
        LargeNavButton(
          text: currentPage < 3 ? currentPage == 2 ? "View all features →" : "Continue →" : "Get Started",
          color: Color.blue
        )
      }
      .padding(.bottom, 30)
      .padding(.horizontal, 29)

      Button {
        showWelcomeScreen = false
      } label: {
        SmallNavButton(
          systemImage: "xmark",
          text: "Close Introduction",
          color: currentPage < 3 ? Color.red : Color.clear,
          symbolLocation: .left
        ).disabled(currentPage >= 3)
      }
      .padding(.bottom, 30)
    }
  }
}

struct WelcomeScreenCard: View {
  @AppStorage("showWelcomeScreen") var showWelcomeScreen = Settings.showWelcomeScreen

  @Binding var currentPage: Int

  var info: [OnboardingInfo]
  var count: Int

  var body: some View {
    VStack {
      if info.first?.group == 1 {
        Text("Welcome to Lunar")
          .bold()
          .font(.largeTitle)
          .lineLimit(5)
          .multilineTextAlignment(.center)
          .padding(.top, 82)
      }

      VStack(spacing: 28) {
        ForEach(info) { section in
          HStack {
            Image(systemName: section.systemImage)
              .foregroundColor(section.color)
              .font(.title)
              .frame(width: 60, height: 50)
              .clipped()
            VStack(alignment: .leading, spacing: 3) {
              Text(section.heading)
                .font(.footnote.bold())
              Text(section.body)
                .font(.footnote)
                .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            Spacer()
          }
        }
      }
      .padding(.top, 40)

//      if info.first?.heading == "Lunar" {
//        Button {
//          showWelcomeScreen = false
//          withAnimation(.bouncy) {
//            currentPage = 3
//          }
//        } label: {
//          SmallNavButton(
//            systemImage: "chevron.right",
//            text: "View all features",
//            color: Color.blue,
//            symbolLocation: .right
//          )
//        }
//        .padding(.top, 30)
//      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .clipped()
    .padding(.bottom, 0)
    .padding(.horizontal, 29)
  }
}

struct WelcomeView_Previews: PreviewProvider {
  static var previews: some View {
    WelcomeView()
  }
}
